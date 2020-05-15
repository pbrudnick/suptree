defmodule Suptree do
  @moduledoc """
  Documentation for Suptree.
  """
  require Logger

  @doc """
  Returns a map of the current cotizations (?)
  """
  @spec show_currencies() :: [map()]
  def show_currencies() do
    GenServer.call(CurrencyWorker, :show)
  end

  @doc """
  Adds a currency to the currencies list.
  """
  @spec add_currency(atom() | binary()) :: :ok
  def add_currency(currency) when is_atom(currency) do
    GenServer.cast(CurrencyWorker, {:add_currency, currency})
  end

  def add_currency(currency) when is_binary(currency) do
    GenServer.cast(CurrencyWorker, {:add_currency, String.to_atom(currency)})
  end

  @doc """
  Returns the current cotizations (?)
  """
  def buy_bitcoin(user, value) do
    GenServer.call(TransactionsWorker, {:buy_bitcoin, user, :usd, value})
  end

  @doc """
  Returns the transactions done by the user
  """
  def request_transactions(user) do
    GenServer.call(TransactionsWorker, {:request_transactions, user})
  end

  @spec nasdak_crash :: :ok
  def nasdak_crash() do
    Logger.error("Oops! something went wrong in Nasdak..")
    GenServer.stop(NasdakPoller, :crash)
  end

  @spec nasdak_crash_state :: :ok
  def nasdak_crash_state() do
    Logger.info("Sending an exhaustive crash state to the Nasdak poller process..")
    GenServer.cast(NasdakPoller, :crash_state)
  end

  @spec nasdak_recover :: :ok
  def nasdak_recover() do
    Logger.info("Sending an exhaustive crash to the Nasdak poller process..")
    # implement it!
  end
end
