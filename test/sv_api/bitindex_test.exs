defmodule SvApi.BitindexTest do
  @moduledoc """
  Bitindex api doc: https://www.bitindex.network/docs.html
  """
  use ExUnit.Case
  alias SvApi.Bitindex

  import Tesla.Mock

  # Determine if it is the utxo format specified in the document
  defp is_utxo(map) do
    for k <- ~w(address amount confirmations height satoshis scriptPubKey txid value vout) do
      Map.has_key?(map, k)
    end |> Enum.all?(&(&1))
  end

  # this address has only one utxo, for speeding up response
  # https://blockchair.com/bitcoin-sv/address/qrl7sf8uzykczlyldqwsg7le35gvhjmzq572s0ewcn
  @addr "1QL7Qbed9X4qfs89bxyKwqwCV9fioGW4Hg"

  test "addrs utxos" do
    assert {:ok, utxos} = Bitindex.utxos(@addr)
    assert Enum.all?(utxos, &is_utxo/1)
  end
end
