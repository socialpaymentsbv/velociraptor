defmodule Velociraptor.HttpcClient do
  defstruct(
    base_url: nil,
    api_key: nil,
    test: false,
    http_options: []
  )

  @options [timeout: 3000, connect_timeout: 30000]

  def init(base_url, api_key, opts \\ []) do
    hashed_api_key =
      "#{api_key}:"
      |> Base.encode64()
      |> :erlang.binary_to_list()

    http_options = Keyword.merge(@options, Keyword.get(opts, :http_options, []))

    opts = Keyword.merge(opts,
      [base_url: base_url, api_key: hashed_api_key, http_options: http_options]
    )

    struct(__MODULE__, opts)
  end
end

defimpl Velociraptor.ClientAPI, for: Velociraptor.HttpcClient do
  def generate(client, type, name, opts \\ []) do
    opts_map =
      opts
      |> Enum.into(%{})
      |> Map.put(:document_type, type)
      |> Map.put(:name, name)

    request(client, opts_map)
  end

  defp request(%{base_url: base_url,
                 test: test,
                 http_options: http_options} = client, params) do

    headers = prepare_headers(client)
    url = :erlang.binary_to_list(base_url)
    json_params =
      params
      |> Map.put(:test, test)
      |> Poison.encode!()

    response = :httpc.request(
      :post,
      {url, headers, 'application/json', json_params},
      http_options,
      body_format: :binary
    )

    sanitize_response(response)
  end

  defp prepare_headers(%{api_key: api_key}) do
    [auth_header(api_key)]
  end

  defp auth_header(key) do
    {'Authorization', ['Basic ', key]}
  end

  defp sanitize_response(response) do
    case response do
      {:ok, {{_httpvs, 200, _status_phrase}, body}} ->
        {:ok, {body}}
      {:ok, {{_httpvs, 200, _status_phrase}, headers, body}} ->
        {:ok, {headers, body}}
      {:ok, {{_httpvs, status, _status_phrase}, body}} ->
        {:error, {status, maybe_parse_xml(body)}}
      {:ok, {{_httpvs, status, _status_phrase}, _headers, body}} ->
        {:error, {status, maybe_parse_xml(body)}}
      {:error, reason} ->
        {:error, {:bad_fetch, reason}}
    end
  end

  defp maybe_parse_xml(string) do
    parsed =
      string
      |> :erlang.binary_to_list
      |> :xmerl_scan.string(quiet: true)

    with {doc, []} <- parsed,
         [error_entry] <- :xmerl_xpath.string('//error/text()', doc),
         {:xmlText, _, _, _, error_message, :text} <- error_entry do
      :erlang.list_to_binary(error_message)
    else
      _ -> string
    end
  end
end
