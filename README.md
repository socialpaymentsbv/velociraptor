# Velociraptor

Minimal [DocRaptor](http://docraptor.com) REST API wrapper for Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `velociraptor` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:velociraptor, "~> 0.1.0"}]
    end
    ```

  2. Ensure `velociraptor` is started before your application:

    ```elixir
    def application do
      [applications: [:velociraptor]]
    end
    ```

  3. Configure `velociraptor` in `config.exs`:

    ```elixir
    config :velociraptor, api_key: <API_KEY>
    ```


## Usage

```elixir
client = Velociraptor.new

{:ok, {headers, body}} = 
  Velociraptor.generate_from_string(
    client, "pdf", "example.pdf", 
    "<html><body>Hello</body></html>")
```
