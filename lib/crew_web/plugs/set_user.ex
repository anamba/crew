defmodule CrewWeb.Plugs.SetUser do
  @moduledoc """
  SetUser plug - copies :current_user_id from assigns to session
  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      nil -> conn
      user -> put_session(conn, :current_user_id, user.id)
    end
  end
end
