defmodule Suptree.CurrencyWorker do
  use GenServer

  def start_link(currencies) when is_list(currencies) do
    GenServer.start_link(__MODULE__, currencies, name: CurrencyWorker)
  end

  # Server (callbacks)

  @impl true
  def init(currencies) do
    {:ok, currencies}
  end

  @impl true
  def handle_call(:show, from, currencies) do
    IO.inspect from
    # simulates going to a 3rd party server and match the currency values
    data =
      currencies
      |> Enum.map(& %{currency: &1, ts: DateTime.utc_now() |> DateTime.to_unix(), value: :rand.uniform_real() / 1000})

    {:reply, data, currencies}
  end

  @impl true
  def handle_cast({:add_currency, currency}, currencies) do
    {:noreply, [currency | currencies]}
  end

  # API

  @doc """
  This will return a map of the current cotizations (?)
  """
  @spec show(GenServer.server()) :: [map()]
  def show(server) do
    GenServer.call(server, :show)
  end

  @doc """
  Adds a currency to the currencies list.
  """
  @spec add(GenServer.server(), atom() | binary()) :: :ok
  def add(server, currency) when is_atom(currency) do
    GenServer.cast(server, {:add_currency, currency})
  end
  def add(server, currency) when is_binary(currency) do
    GenServer.cast(server, {:add_currency, String.to_atom(currency)})
  end
end
