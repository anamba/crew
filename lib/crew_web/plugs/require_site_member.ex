defmodule CrewWeb.Plugs.RequireSiteMember do
  @moduledoc """
  RequireSiteMember plug - ensure that current user is a member of current site
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with {:ok, site} <- Map.fetch(conn.assigns, :current_site),
         {:ok, user} <- Map.fetch(conn.assigns, :current_user),
         {:ok, _} <- Crew.Sites.fetch_site_member(site.id, user.id) do
      conn
    else
      _ ->
        conn
        |> put_flash(:error, "You are not allowed to access that site, please check the URL.")
        |> redirect(to: "/")
        |> halt()
    end
  end
end
