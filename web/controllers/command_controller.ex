defmodule TryElixir.CommandController do
  use TryElixir.Web, :controller

  def run(conn, %{"content" => content}) do
    result =
      content
      |> Code.eval_string
      |> elem(0)

    conn
    |> json %{resp: result}
  end
end
