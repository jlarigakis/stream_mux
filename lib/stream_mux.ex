defmodule StreamMux do
  alias Porcelain.Process, as: Proc
  alias StreamMux.Router
  require Logger
  @moduledoc """
  Documentation for StreamMux
  """

  def main(commands) do
    {:ok, router} = Router.start_link()
    {:ok, _} = Plug.Adapters.Cowboy.http StreamMux.LogPlug, [service: router]
    Logger.info "Listening on port 4000"

    commands
    |> stream
    |> Stream.each(&Router.send_log_entry(router, &1))
    |> Stream.run
  end

  def stream(commands) do
    pids = Enum.map(commands, fn command ->
      %Proc{pid: pid} = Porcelain.spawn_shell command, out: {:send, self()}
      pid
    end)
    Stream.resource(
      fn -> pids end,
      fn pids ->
        receive do
          {_pid, :data, :out, item} ->
            {[item], pids}
          _ ->
            case Enum.filter(pids, &Process.alive?/1) do
              [] ->
                {:halt, []}
              alive_pids ->
                {[], alive_pids}
            end
        end
      end,
      fn _ -> nil end)
  end
end
