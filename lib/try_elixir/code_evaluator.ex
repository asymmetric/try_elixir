defmodule TryElixir.CodeEvaluator do
  use GenServer

  def start_link(name) do
    GenServer.start_link __MODULE__, :ok, name: name
  end

  def run(code) do
    GenServer.call __MODULE__, {:run, code}
  end

  def handle_call({:run, code}, _from, _state) do
    {:ok, device} = StringIO.open ""
    :erlang.group_leader(device, self)

    task = Task.async(run_code(code, device))
    {:ok, reply} = Task.yield(task, 5000)

    IO.inspect device, reply

    output =
      device
      |> StringIO.contents
      |> elem(1)

    StringIO.close device

    {:reply, output, nil}
  end

  defp run_code(code, device) do
    try do
      code
      |> Code.eval_string
      |> elem(0)
    rescue
      exception -> Exception.message(exception)
    end
  end
end
