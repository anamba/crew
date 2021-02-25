defmodule CrewWeb.SignupController do
  use CrewWeb, :controller

  alias Crew.Repo
  alias Crew.Signups

  @headers [
    "Guest First Name",
    "Guest Last Name",
    gettext("Activity"),
    gettext("Time Slot")
  ]

  def download_csv(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("application/csv")
      |> put_resp_header("content-disposition", "attachment; filename=signups.csv")
      |> send_chunked(200)

    {:ok, conn} = chunk(conn, :unicode.encoding_to_bom(:utf8))

    Repo.transaction(fn ->
      Signups.stream_signups(conn.assigns.current_site.id)
      |> Stream.map(&signup_to_csv_row/1)
      |> CSV.encode(headers: @headers)
      |> Enum.into(conn)
    end)

    # ?? this doesn't seem right
    conn
  end

  defp signup_to_csv_row(signup) do
    %{
      "Guest First Name" => signup.guest.first_name,
      "Guest Last Name" => signup.guest.last_name,
      gettext("Activity") => signup.activity.name,
      gettext("Time Slot") => signup.time_slot.name
    }
  end
end
