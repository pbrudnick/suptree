# Supervision Tree

This is a _sandbox_ app, intended to test how to create a supervision tree and its different strategies.

## Requirements
Erlang and Elixir 1.9

## Run
```
iex -S mix
```

This will setup a supervision tree with:

```
       Suptree.Supervisor
      /         |         \
     /          |          \
CurrencyW TransactionsW NasdakSup
                            |
                            |
                      NasdakPoller
```

Interact with the app with its API:

```elixir
iex(1)> Suptree.show_currencies()
[
  %{currency: :usd, ts: 1588193109, value: 4.812998482221626e-4},
  %{currency: :eur, ts: 1588193109, value: 6.930400003796827e-4}
]
iex(2)> Suptree.add_currency(:yen)
:ok
iex(3)> Suptree.show_currencies() 
[
  %{currency: :yen, ts: 1588193191, value: 8.208433554391529e-4},
  %{currency: :usd, ts: 1588193191, value: 6.363158641621043e-4},
  %{currency: :eur, ts: 1588193191, value: 3.816745053861492e-4}
]
iex(4)> Suptree.buy_bitcoin("pablo", 100)
0.012
iex(5)> Suptree.buy_bitcoin("pablo", 80) 
0.009600000000000001
iex(6)> Suptree.request_transactions("pablo")
[{:usd, 0.009600000000000001, 1588193221}, {:usd, 0.012, 1588193214}]
```

Try to crash the `NasdakPoller`:
```
Suptree.nasdak_crash()
```
or directly:
```
GenServer.stop(NasdakPoller, :crash)
```
And check the pids of the supervision tree, if this affects the `CurrencyWorker` and `TransactionsWorker`.

## Playing with the strategies
The `child_specification` of the children processes could be changed, specially the: `:restart` and `:shutdown` opts.
Change the `:max_restarts` and `:max_seconds` of the `NasdakSup`.