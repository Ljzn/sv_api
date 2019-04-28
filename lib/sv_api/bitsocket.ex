defmodule SvApi.Bitsocket do


  def subscribe(addr) do
    pid = self()
    spawn_link(fn -> start_sse(pid, addr) end)
  end

  defp start_sse(parent, addr) do
    b64 = build_query(addr)
    {:ok, pid} = SseClient.new("https://genesis.bitdb.network/s/1FnauZ9aUH2Bex6JzdcV4eNX7oLSSEbxtN/" <> b64, stream_to: self())
    ref = Process.monitor(pid)
    do_listen(parent, addr, ref)
  end

  defp do_listen(parent, addr, ref) do
    receive do
      %EventsourceEx.Message{data: data} ->
        case parse_data(data) do
          {:ok, msg} ->
            send parent, {:bitsocket, msg}
          _ ->
            nil
        end
        do_listen(parent, addr, ref)
      {:DOWN, ^ref, _, _pid, _} ->
        start_sse(parent, addr)
      other ->
        IO.inspect other, label: "bitsocket"
        do_listen(parent, addr, ref)
    end
  end

  def parse_data(data) do
    # IO.inspect data
    json = Jason.decode!(data)
    case json["type"] do
      "u" ->
        {:ok, json["data"]}
      _ ->
        nil
    end
  end

  @doc """
  """
  def build_query(addr) do
    """
    {
      "v": 3,
      "q": {
        "find": {
          "out.e.a": "#{addr}"
        }
      },
      "r": {
        "f": ".[] | { txid: .tx.h, from: [.in[] | { sender: .e.a }], to: [.out[] | { receiver: .e.a, amount: .e.v? }] }"
      }
    }
    """
    |> Base.encode64()
  end
end
