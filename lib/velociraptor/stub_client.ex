defmodule Velociraptor.StubClient do
  defstruct stub_requests: true

  def init(), do: %__MODULE__{}
end

defimpl Velociraptor.ClientAPI, for: Velociraptor.StubClient do
  require Logger

  def generate(_, type, name, opts) do
    suffix = if opts[:document_url] do
      " from url #{opts[:document_url]}"
    else
      ""
    end

    Logger.warn "[VELOCIRAPTOR-STUB] Generating #{type} file #{name}#{suffix}"
    {:ok, {""}}
  end
end
