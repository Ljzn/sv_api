defmodule SvApi.Bitindex do
  use Tesla

  @moduledoc """
  Bitindex Api V3.
  """

  @api_key Application.get_env(:sv_api, :bitindex_api_key)

  plug Tesla.Middleware.BaseUrl, "https://api.bitindex.network/api/v3/"
  plug Tesla.Middleware.Headers, [{:api_key, @api_key}]
  plug Tesla.Middleware.JSON


  def utxos(addr, net) do
    url = net <> "/addr/#{addr}/utxo"
    case get(url) do
      {:ok, resp} ->
        {:ok, resp.body}
      {:error, msg} ->
        {:error, msg}
    end
  end

  def broadcast(tx, net) do
    url = net <> "/tx/send"
    case post(url, %{rawtx: tx}) do
      {:ok, resp} ->
        case Map.get(resp.body, "message") do
          nil ->
            txid = Map.get(resp.body, "txid")
            {:ok, txid}
          other ->
            {:error, other["message"]}
        end
      {:error, msg} ->
        {:error, msg}
    end
  end

  def transaction(txid, net) do
    url = net <> "/rawtx/#{txid}"
    case get(url) do
      {:ok, resp} ->
        if Map.has_key?(resp.body, "errors") do
          {:error, resp.body}
        else
          {:ok, resp.body["rawtx"]}
        end
      {:error, msg} ->
        {:error, msg}
    end
  end

end
