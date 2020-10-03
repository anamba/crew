defmodule CrewWeb.Plugs.SetPerson do
  @moduledoc """
  SetSite plug - sets conn.assigns[:current_site] based on host header
  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    assign(conn, :current_person, Crew.Persons.get_person(get_session(conn, :person_id)))
  end
end
