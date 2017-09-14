defmodule StreamMux.Router do
  use GenServer
  require Logger

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default)
  end

  def subscribe(pid) do
    GenServer.call(pid, :subscribe)
  end

  def send_log_entry(pid, log_entry) do
    GenServer.cast(pid, {:log_entry, log_entry})
  end

  def handle_call(:subscribe, {pid, _ref}, subscribers) do
    {:reply, :ok, [pid | subscribers]}
  end

  def handle_cast({:log_entry, entry}, subscribers) do
    for subscriber <- subscribers,
        do: send(subscriber, {:log_entry, entry})
    {:noreply, subscribers}
  end
end
