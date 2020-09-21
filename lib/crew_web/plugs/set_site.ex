defmodule CrewWeb.Plugs.SetSite do
  @moduledoc """
  SetSite plug - sets conn.assigns[:current_site] based on host header
  """

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    site = lookup_site(conn)

    conn
    |> Plug.Conn.put_session(:site_id, if(site, do: site.id))
    |> Plug.Conn.put_session(:site_slug, if(site, do: site.slug))
  end

  defp lookup_site(conn) do
    # first, try to match the entire hostname to a site's primary domain
    case CrewWeb.get_site_from_host(conn) do
      nil ->
        # if that fails, just try to extract a slug and match on that
        site_slug =
          if System.get_env("MIX_ENV") == "test" do
            "test"
          else
            CrewWeb.get_site_slug_from_host(conn) || conn.params["site"]
          end

        site_slug && Crew.Sites.get_site_by(slug: site_slug)

      site ->
        site
    end
  end
end
