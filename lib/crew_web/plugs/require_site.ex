defmodule CrewWeb.Plugs.RequireSite do
  @moduledoc """
  RequireSite plug - ensure that conn has a value for :site_id in session
  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if get_session(conn, :site_id) do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Could not find that site, please check the URL.")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()
    end
  end
end
