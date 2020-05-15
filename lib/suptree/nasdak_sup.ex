defmodule Suptree.NasdakSup do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Suptree.NasdakPoller, []}
    ]

    # defaults: max_restarts: 3, max_seconds: 5
    Supervisor.init(children, strategy: :one_for_one)
  end
end
