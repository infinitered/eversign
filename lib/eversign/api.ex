defmodule Eversign.API do
  @moduledoc """
  Behaviour module for the Eversign API. See the official Eversign
  documentation for more details:

  https://eversign.com/api/documentation/methods
  """

  @callback use_template(map) ::
    {:ok, map} |
    {:error, HTTPoison.Error.t}

  @callback list_documents(String.t) ::
    {:ok, [map]} |
    {:error, HTTPoison.Error.t}

  @callback download_original(String.t) ::
    :ok | # TODO: File?
    {:error, HTTPoison.Error.t}

  @callback download_final(String.t) ::
    :ok | # TODO: File?
    {:error, HTTPoison.Error.t}

  @callback get_document(String.t) ::
    {:ok, Eversign.Document.t} |
    {:error, HTTPoison.Error.t}

  # @callback list_businesses ::
    # {:ok, [Eversign.Business.t]} |
    # {:error, HTTPoison.Error.t}

  # @callback create_document(map) ::
    # {:ok, Eversign.Document.t} |
    # {:error, HTTPoison.Error.t}

  # @callback send_reminder(String.t, String.t) ::
    # :ok |
    # {:error, HTTPoison.Error.t}

  # @callback delete_document(String.t) ::
    # :ok |
    # {:error, HTTPoison.Error.t}

  @callback cancel_document(String.t) ::
    :ok |
    {:error, HTTPoison.Error.t}

  # @callback upload(String.t) ::
    # {:ok, map} |
    # {:error, HTTPoison.Error.t}
end
