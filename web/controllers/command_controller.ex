defmodule TryElixir.CommandController do
  @blacklist ~r/:erlang.halt|:init.(stop|restart|(re)?boot)/
  use TryElixir.Web, :controller

  def create(conn, %{"content" => content}) do
    content
    |> safe_input?
    |> safe_render(conn)
  end

  defp safe_input?(content) do
    cond do
      String.match? content, @blacklist -> {:unsafe, content}
      true -> {:safe, content}
    end
  end

  defp safe_render({:unsafe, _content}, conn), do: conn |> json(%{resp: "no no no"})
  defp safe_render({:safe, content}, conn) do
    result = TryElixir.CodeEvaluator.run(content)

    conn |> json(%{resp: result})
  end
end
