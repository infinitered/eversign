defmodule Eversign.API.HTTP do
  use HTTPoison.Base

  @behaviour Eversign.API

  alias Eversign.Config

  @opts [timeout: 25_000, recv_timeout: 25_000]

  def use_template(params, opts \\ nil) do
    unwrap post("/document", Poison.encode!(params), [{"Content-Type", "application/json"}], opts || @opts)
  end

  def get_document(hash, opts \\ nil) do
    unwrap get("/document?document_hash=#{hash}", [], opts || @opts)
  end

  def cancel_document(hash) do
    unwrap delete("/document?document_hash=#{hash}&cancel=1")
  end

  def list_documents(type, opts \\ nil) do
    unwrap get("/document?type=#{type}", [], opts || @opts)
  end

  def download_original(hash) do
    unwrap get("/download_raw_document?document_hash=#{hash}")
  end

  def download_final(hash) do
    unwrap get("download_final_document?document_hash=#{hash}&audit_trail=1")
  end

  # HTTPoison Callbacks
  # -------------------

  def process_url(path) do
    query =
      if path =~ "?" do
        "&" <> credentials()
      else
        "?" <> credentials()
      end

    "https://api.eversign.com/api" <> path <> query
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end

  # Helpers
  # -------------------

  defp unwrap({:ok, %{body: %{"success" => false} = body}}) do
    {:error, Eversign.Exception.exception(body)}
  end
  defp unwrap({:ok, %{body: body}}), do: {:ok, body}
  defp unwrap(other), do: other

  defp credentials do
    access_key = Config.from_env(:eversign, :access_key)
    business_id = Config.from_env(:eversign, :business_id)

    "access_key=#{access_key}&business_id=#{business_id}"
  end
end
