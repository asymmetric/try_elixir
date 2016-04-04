defmodule TryElixir.CommandController do
  use TryElixir.Web, :controller

  def create(conn, %{"content" => content}) do
    case safe_input?(content) do
      :unsafe ->
        conn |> json(%{resp: "no no no"})
      :safe ->
        result = TryElixir.CodeEvaluator.run(content)

        conn |> json(%{resp: result})
    end
  end

  defp safe_input?(content) do
    cond do
      String.match? content, ~r/:erlang.halt/ -> :unsafe
      String.match? content, ~r/:init.stop/ -> :unsafe
      true -> :safe
    end
  end
end
