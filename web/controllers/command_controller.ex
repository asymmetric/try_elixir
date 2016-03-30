defmodule TryElixir.CommandController do
  use TryElixir.Web, :controller

  def create(conn, %{"content" => content}) do
    {:ok, device} = StringIO.open ""
    :erlang.group_leader(device, self)

    try do
      result =
        content
        |> Code.eval_string
        |> elem(0)

      IO.inspect result
    rescue
      exception -> IO.inspect Exception.message(exception)
    end

    output =
      device
      |> StringIO.contents
      |> elem(1)

    conn
    |> json(%{resp: output})
  end
end
