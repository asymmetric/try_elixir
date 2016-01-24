defmodule TryElixir.CommandController do
  use TryElixir.Web, :controller

  def run(conn, %{"content" => content}) do
    {:ok, device} = StringIO.open ""
    :erlang.group_leader(device, self)

    result =
      content
      |> Code.eval_string
      |> elem(0)

    IO.puts device, result

    output =
      device
      |> StringIO.contents
      |> elem(1)

    conn
    |> json(%{resp: output})
  end
end
