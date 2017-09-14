defmodule StreamMux.LogPlug do
  import Plug.Conn
  require Logger
  alias StreamMux.Router

  def init(options) do
    options
  end

  def call(conn, opts) do
    Logger.info "Client connected #{inspect conn.remote_ip}"

    Router.subscribe opts[:service]
    conn = conn
    |> put_resp_content_type("text/plain")
    |> send_chunked(200)
    |> forward_messages
  end

  defp forward_messages(conn) do
    receive do
      {:log_entry, entry} ->
        case chunk(conn, "#{entry}\n") do
          {:ok, conn} -> forward_messages(conn)
          {:error, :closed} ->
            Logger.info "Client disconnected #{inspect conn.remote_ip}"
            exit(:shutdown)
        end
      {:done} -> conn
    end
  end
end
