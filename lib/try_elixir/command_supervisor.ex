defmodule TryElixir.CommandSupervisor do
  use Supervisor

  def start_link do
    result = {:ok, sup} = Supervisor.start_link __MODULE__, []
  end

  def init(_) do
    children = [
      worker(TryElixir.CodeEvaluator, [TryElixir.CodeEvaluator])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
