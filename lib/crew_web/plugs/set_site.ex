defmodule CrewWeb.Plugs.SetSite do
  @moduledoc """
  SetSite plug - sets conn.assigns[:current_site] based on host header
  """

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    site_slug =
      if System.get_env("MIX_ENV") == "test" do
        "test"
      else
        CrewWeb.get_site_slug_from_host(conn) || conn.params["site"]
      end

    site = site_slug && Crew.Sites.get_site_by(slug: site_slug)
    Plug.Conn.assign(conn, :current_site, site)
  end
end
