defmodule Suptree.TransactionsWorker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: TransactionsWorker)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:buy_bitcoin, user, :usd, value}, _from, state) do
    # simulates going to a 3rd party exchange and buying bitcoins
    total_to_buy = 0.00012 * value
    # register the purchase
    user_transactions = Map.get(state, user, [])
    ts = DateTime.utc_now() |> DateTime.to_unix()
    user_transactions = [{:usd, total_to_buy, ts} | user_transactions]
    new_state = Map.put(state, user, user_transactions)

    {:reply, total_to_buy, new_state}
  end
  @impl true
  def handle_call({:buy_bitcoin, _user, _currency}, _from, state) do
    {:reply, :cannot_buy, state}
  end

  @impl true
  def handle_call({:request_transactions, user}, _from, state) do
    {:reply, Map.get(state, user, []), state}
  end

  # API

  @doc """
  This will return a map of the current cotizations (?)
  """
  @spec buy_bitcoin(GenServer.server(), binary(), float()) :: float()
  def buy_bitcoin(server, user, value) do
    GenServer.call(server, {:buy_bitcoin, user, :usd, value})
  end

  @spec request_transactions(GenServer.server(), binary()) :: list()
  def request_transactions(server, user) do
    GenServer.call(server, {:request_transactions, user})
  end
end
