defmodule Suptree.NasdakPoller do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: NasdakPoller)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    Logger.info("NasdakPoller started with pid=#{inspect(self())}")
    poll()

    {:ok, state}
  end

  @impl true
  def handle_info(:poll, state) do
    # simulating: gets info from nasdak servers and writes in some databases..
    #raise "oops"
    poll()

    {:noreply, state}
  end

  defp poll() do
    Process.send_after(self(), :poll, 1000)
  end

  # API
  def crash(server) do
    Logger.error("Oops! something went wrong in Nasdak..")
    GenServer.stop(server, :crash)
  end

end
