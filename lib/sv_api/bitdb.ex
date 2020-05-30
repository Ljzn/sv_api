defmodule SvApi.Bitdb do
  use Tesla
  @api_key "1DkBxWipgByk5ZCoQ6KVKvTZTY11DmSB5x"

  plug Tesla.Middleware.BaseUrl, "https://genesis.bitdb.network/q/1FnauZ9aUH2Bex6JzdcV4eNX7oLSSEbxtN"
  plug Tesla.Middleware.Headers, [{:key, @api_key}]
  plug Tesla.Middleware.JSON

  def transactions(addr, limit) do
    query =
      """
      {
        "v": 3,
        "q": {
          "limit": #{limit},
          "find": {
            "out.e.a": "#{addr}"
          }
        },
        "r": {
          "f": "[.[] | { txid: .tx.h, from: [.in[] | { sender: .e.a }], to: [.out[] | { receiver: .e.a, amount: .e.v? }] }]"
        }
      }
      """ |> Base.encode64()
    case get(query) do
      {:ok, resp} ->
        {:ok, Map.get(resp.body, "c")}
      {:error, msg} ->
        {:error, msg}
    end
  end

  def query(q) do
    query = q |> Base.encode64()
    case get(query) do
      {:ok, resp} ->
        {:ok, resp.body}
      {:error, msg} ->
        {:error, msg}
    end
  end

end
