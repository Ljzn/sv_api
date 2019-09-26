# SvApi

Elixir SDK for multiple third-party BitcoinSV apis.

## Installation

```elixir
def deps do
  [
    {:sv_api, github: "terriblecodebutwork/sv_api"}
  ]
end
```

## Apis

set the api module and api key in your config file:
```exs
config :sv_api, mods: [SvApi.Bitindex]
config :sv_api, bitindex_api_key: "" #your api key
```

supported:
```ex
SvApi.broadcast(tx) # hex string raw tx
SvApi.transaction(txid) # get raw tx with txid
SvApi.utxos(addr) # get utxos with address
```