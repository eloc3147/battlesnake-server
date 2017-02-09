defmodule BattleSnake.GameAdminChannel do
  alias Phoenix.Socket
  alias BattleSnake.GameServer
  alias BattleSnake.GameServer.PubSub
  alias BattleSnake.GameServer.Registry
  use BattleSnake.Web, :channel

  @requests ~w(resume next prev)

  def join("game_admin:" <> game_id, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game_id, game_id)
      {:ok, pid} = game_server(game_id)
      socket = assign(socket, :game_server_pid, pid)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def available_requests, do: @requests

  def handle_in(request, from, socket) when request in @requests do
    request = String.to_existing_atom(request)
    handle_in(request, from, socket)
  end

  def handle_in(request, from, socket) when is_atom(request) do
    pid = game_server(socket)
    GenServer.call(pid, request)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp game_id(%Socket{} = socket) do
    socket.assigns.game_id
  end

  defp game_server(%Socket{} = socket) do
    socket.assigns.game_server_pid
  end

  defp game_server(game_id) when is_binary(game_id) do
    Registry.lookup_or_create(game_id)
  end
end
