# SvApi

Elixir SDK for multiple third-party BitcoinSV apis.

## Installation

```elixir
def deps do
  [
    {:sv_api, github: "0xwallet/sv_api"}
  ]
end
```

## Example

**Bitindex api: get utxos for address**

```elixir
SvApi.Bitindex.utxos("1L9D9Zv9BFqTQScFJzz8rXiUjnmnGxRBvk")
```

will get
```ex
 [
    %{
      "address" => "1L9D9Zv9BFqTQScFJzz8rXiUjnmnGxRBvk",
      "amount" => 8.88e-6,
      "confirmations" => 4393,
      "height" => 574803,
      "satoshis" => 888,
      "scriptPubKey" => "76a914d1f7dba524ba2be249981eda3e472170a6e1c3a988ac",
      "txid" => "db2f3a28b1d9591988ad3e473571ed2bf187efd520b31aafa3c7694de1bd5979",
      "value" => 888,
      "vout" => 1
    },
    ...
  ]
```