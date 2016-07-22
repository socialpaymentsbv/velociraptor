defmodule VelociraptorTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  test "generates a PDF from a provided HTML string" do
    use_cassette "generate_pdf_from_string" do
      client = Velociraptor.new
      {:ok, {headers, body}} = Velociraptor.generate_from_string(
        client,
        "pdf",
        "test.pdf",
        "<html><body>Hello</body></html>"
      )

      assert byte_size(body) > 0
      assert List.keyfind(headers, 'content-type', 0) == {
        'content-type', 'application/pdf'
      }
      {_, disposition} = List.keyfind(headers, 'content-disposition', 0)
      assert :erlang.list_to_binary(disposition) =~ "test.pdf"
    end
  end

  test "generates a PDF from a provided URL" do
    use_cassette "generate_pdf_from_url" do
      client = Velociraptor.new
      {:ok, {headers, body}} = Velociraptor.generate_from_url(
        client,
        "pdf",
        "test.pdf",
        "https://google.com"
      )

      assert byte_size(body) > 0
      assert List.keyfind(headers, 'content-type', 0) == {
        'content-type', 'application/pdf'
      }
      {_, disposition} = List.keyfind(headers, 'content-disposition', 0)
      assert :erlang.list_to_binary(disposition) =~ "test.pdf"
    end
  end

  test "returns an error on wrong input" do
    use_cassette "error on wrong input" do
      client = Velociraptor.new
      {:error, {status, message}} = Velociraptor.generate_from_url(
        client,
        "pdf",
        "test.pdf",
        "malformed://address"
      )

      assert status == 422
      assert is_binary(message)
    end
  end
end
