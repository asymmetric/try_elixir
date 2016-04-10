defmodule TryElixir.CodeEvaluator do
  use GenServer

  def start_link(name) do
    GenServer.start_link __MODULE__, :ok, name: name
  end

  def run(code) do
    GenServer.call __MODULE__, {:run, code}, :infinity
  end

  def handle_call({:run, code}, _from, _state) do
    {:ok, device} = StringIO.open ""
    :erlang.group_leader(device, self)

    task = Task.async(fn -> run_code(code) end)

    Task.yield(task, 5000)
    |> handle_task_reply(task)

    output =
      device
      |> StringIO.contents
      |> elem(1)

    StringIO.close device

    {:reply, output, nil}
  end

  defp run_code(code) do
    try do
      code
      |> Code.eval_string
      |> elem(0)
    rescue
      exception -> Exception.message(exception)
    end
  end

  defp handle_task_reply({_, reply}, _task), do: IO.inspect reply
  defp handle_task_reply(nil, task) do
    IO.inspect "timeout!"
    Task.shutdown(task, :brutal_kill)
  end
end
