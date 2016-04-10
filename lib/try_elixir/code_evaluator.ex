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

    task = Task.async(fn -> run_code(code) end)

    Task.yield(task, 5000)
    |> handle_task_reply(device)

    Task.shutdown(task, :brutal_kill)

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

  defp handle_task_reply({:ok, reply}, device) do
    IO.inspect device, reply, []
  end

  defp handle_task_reply({:exit, reason}, device) do
    IO.inspect device, reason, []
  end

  defp handle_task_reply(nil, device) do
    IO.puts "timeout!"
  end
end
