# Eversign

Package for interacting with [Eversign's API](https://eversign.com/api/documentation).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `eversign` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:eversign, "~> 0.1.0"}]
end
```

## Usage

In your config file:

```elixir
  ## In prod/dev config

      config :eversign,
        access_key: {:system, "EVERSIGN_ACCESS_KEY"},
        business_id: {:system, "EVERSIGN_BUSINESS_ID"},
        api_module: Eversign.API.HTTP

  ## In test config:

      config :eversign,
        access_key: {:system, "EVERSIGN_ACCESS_KEY"},
        business_id: {:system, "EVERSIGN_BUSINESS_ID"},
        api_module: Eversign.API.Mock
```

Create document using a template:

```elixir
  def create_eversign(opts) do
    %{ address: address, client: client } = opts

    params = %{
      template_id: "TemplateIDHere",
      title: "My Template Title",
      message: "Please sign this document for our records.",
      signers: [%{
        role: "Client",
        name: client.full_name,
        email: client.email,
      }, %{
        role: "Account Manager",
        name: "Jamon Holmgren",
        email: "jamon@infinite.red",
      }],
      fields: [%{
        identifier: "full-name",
        value: client.full_name
      },
      %{
        identifier: "street-address",
        value: "#{address.line_1}, #{address.line_2}"
      },
      %{
        identifier: "city-state-zip",
        value: "#{address.city}, #{address.state}, #{address.zip_code}"
      }]
    }

    %{ :ok, _data } = Evernote.use_template(params)
  end
```

Retrieve a document using a document ID:

```elixir
  document = Eversign.get_document("document ID here")
```

_TODO: Add rest of API, more examples._


