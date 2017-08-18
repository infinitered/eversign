defmodule Eversign do
  @moduledoc """
  Provides functions to interact with the Eversign API.

  ## Configuration

      config :eversign, api_module: Eversign.API.HTTP

  In test mode:

      config :eversign, api_module: Eversign.API.Mock
  """

  def use_template(params) do
    api_module().use_template(params)
  end

  def get_document(hash) do
    api_module().get_document(hash)
  end

  def cancel_document(hash) do
    api_module().cancel_document(hash)
  end

  def list_documents(type) do
    api_module().list_documents(type)
  end

  def download_original(hash) do
    api_module().download_original(hash)
  end

  def download_final(hash) do
    api_module().download_final(hash)
  end

  defp api_module do
    Application.get_env(:eversign, :api_module) || Eversign.API.HTTP
  end
end
