defmodule SvApi.Bitindex do
  use Tesla

  @api_key "44UFrLxSBgPxt4mibqw9m9voHps7RbgT1j92YE1K7XUKefBPLMiPXq7e5Lrmpp8NWa"

  plug Tesla.Middleware.BaseUrl, "https://api.bitindex.network/api/v2"
  plug Tesla.Middleware.Headers, [{:api_key, @api_key}]
  plug Tesla.Middleware.JSON


  def utxos(addr) do
    case get("addrs/utxos?address=#{addr}") do
      {:ok, resp} ->
        Map.get(resp.body, "data")
      {:error, msg} ->
        raise(msg)
    end
  end

end
