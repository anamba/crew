defmodule CrewWeb.Plugs.SetSite do
  @moduledoc """
  SetSite plug - sets :site_id and :site_slug in session based on host header/url
  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case lookup_site(conn) do
      nil ->
        conn

      site ->
        conn = assign(conn, :current_site, site)

        if get_session(conn, :site_id) == site.id do
          conn
        else
          conn
          |> put_session(:site_id, site.id)
          |> put_session(:site_slug, site.slug)
        end
    end
  end

  defp lookup_site(conn) do
    # first, try to match the entire hostname to a site's primary domain
    site = CrewWeb.get_site_from_host(conn)

    # if that fails, try to extract slug from url
    site_slug = CrewWeb.get_site_slug_from_host(conn) || conn.params["site"]

    cond do
      System.get_env("MIX_ENV") == "test" -> Crew.Sites.get_site_by(slug: "test")
      site -> site
      site_slug -> Crew.Sites.get_site_by(slug: site_slug)
      true -> nil
    end
  end
end
