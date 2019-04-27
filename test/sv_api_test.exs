defmodule SvApiTest do
  use ExUnit.Case

  @addr "1QL7Qbed9X4qfs89bxyKwqwCV9fioGW4Hg"

  test "addrs utxos" do
    assert {:ok, utxos} = SvApi.utxos(@addr)
  end
end
