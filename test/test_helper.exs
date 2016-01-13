ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TryElixir.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TryElixir.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TryElixir.Repo)

