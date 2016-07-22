defmodule Velociraptor do
  alias Velociraptor.ClientAPI

  @default_base_url "https://docraptor.com/docs"

  def new(base, api_key, opts \\ []) do
    stub_requests = Keyword.get(opts, :stub_requests, false)

    if stub_requests do
      Velociraptor.StubClient.init()
    else
      Velociraptor.HttpcClient.init(base, api_key, opts)
    end
  end

  def new do
    api_key = Application.fetch_env!(:velociraptor, :api_key)
    base_url = Application.get_env(:velociraptor, :base_url, @default_base_url)
    test = Application.get_env(:velociraptor, :test, false)
    stub_requests = Application.get_env(:velociraptor, :stub_requests, false)
    http_options = Application.get_env(:velociraptor, :http_options, [])

    new(base_url, api_key,
      test: test,
      stub_requests: stub_requests,
      http_options: http_options)
  end

  def generate_from_string(%{} = client, type, name, content, opts \\ [])
  when type in ["pdf", "xls", "xlsx"] and is_binary(name) do
    opts = [{:document_content, content} | opts]
    ClientAPI.generate(client, type, name, opts)
  end

  def generate_from_url(%{} = client, type, name, url, opts \\ [])
  when type in ["pdf", "xls", "xlsx"] and is_binary(name) do
    opts = [{:document_url, url} | opts]
    ClientAPI.generate(client, type, name, opts)
  end
end
