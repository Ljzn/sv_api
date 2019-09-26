defmodule SvApi do
  @moduledoc """
  Documentation for SvApi.
  """
  alias SvApi.Bitindex

  @mods Application.get_env(:sv_api, :mods)


  def utxos(addr) do
    many_tasks_one_response(:utxos, [addr])
  end

  def broadcast(tx) do
    many_tasks_one_response(:broadcast, [tx])
  end

  def transaction(txid) do
    many_tasks_one_response(:transaction, [txid])
  end

  def many_tasks_one_response(function, args) do
    pid = self()
    tasks = for mod <- @mods do
      spawn(fn ->
        resp = apply(mod, function, [args])
        send pid, {:resp, resp}
      end)
    end
    receive do
      {:resp, resp} ->
        for pid <- tasks do
          Process.exit(pid, :kill)
        end
        resp
    after
      10_000 ->
        {:error, :timeout}
    end
  end

end
