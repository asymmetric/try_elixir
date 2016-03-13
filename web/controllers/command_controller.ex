defmodule TryElixir.CommandController do
  use TryElixir.Web, :controller

  def create(conn, %{"content" => content}) do
    {:ok, device} = StringIO.open ""
    :erlang.group_leader(device, self)

    result =
      content
      |> Code.eval_string
      |> elem(0)

    IO.inspect device, result, []

    output =
      device
      |> StringIO.contents
      |> elem(1)

    conn
    |> json(%{resp: output})
  end
end
