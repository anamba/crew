defmodule CrewWeb.Plugs.RequireAdmin do
  @moduledoc """
  RequireAdmin plug - ensure that current user has admin flag set
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with {:ok, user} <- Map.fetch(conn.assigns, :current_user),
         true <- user.admin do
      conn
    else
      _ ->
        conn
        |> put_flash(:error, "You are not allowed to access that page.")
        |> redirect(to: "/")
        |> halt()
    end
  end
end
