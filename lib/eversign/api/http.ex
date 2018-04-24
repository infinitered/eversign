defmodule Eversign.API.HTTP do
  use HTTPoison.Base

  @behaviour Eversign.API

  alias Eversign.Config

  @opts [timeout: 25_000, recv_timeout: 25_000]

  def use_template(params, opts \\ nil) do
    unwrap(
      post(
        "/document",
        Poison.encode!(params),
        [{"Content-Type", "application/json"}],
        opts || http_opts()
      )
    )
  end

  def get_document(hash, opts \\ nil) do
    unwrap(get("/document?document_hash=#{hash}", [], opts || http_opts()))
  end

  def cancel_document(hash) do
    unwrap(delete("/document?document_hash=#{hash}&cancel=1", [], http_opts()))
  end

  def list_documents(type, opts \\ nil) do
    unwrap(get("/document?type=#{type}", [], opts || http_opts()))
  end

  def download_original(hash) do
    unwrap(get("/download_raw_document?document_hash=#{hash}", [], http_opts()))
  end

  def download_final(hash) do
    unwrap(get("download_final_document?document_hash=#{hash}&audit_trail=1", [], http_opts()))
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
    if Code.ensure_loaded?(Honeybadger) do
      apply(Honeybadger, :context, [%{response: body}])
    end

    Poison.decode!(body)
  end

  # Helpers
  # -------------------

  defp unwrap({:ok, %{body: %{"success" => false} = body}}) do
    {:error, Eversign.Exception.exception(body)}
  end

  defp unwrap({:ok, %{status_code: status_code, body: body}}) when status_code in 200..299,
    do: {:ok, body}

  defp unwrap({:ok, %{body: body}}) do
    {:error, Eversign.Exception.exception(body)}
  end

  defp unwrap(other), do: other

  defp credentials do
    access_key = Config.from_env(:eversign, :access_key)
    business_id = Config.from_env(:eversign, :business_id)

    "access_key=#{access_key}&business_id=#{business_id}"
  end

  defp http_opts do
    [
      timeout: Config.from_env(:eversign, :timeout) || @opts[:timeout],
      recv_timeout: Config.from_env(:eversign, :recv_timeout) || @opts[:recv_timeout]
    ]
  end
end
