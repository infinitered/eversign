defmodule Eversign.Exception do
  defexception [:message, :api]
  
  def exception(api) do
    %__MODULE__{message: api["error"]["info"], api: api}
  end
end
