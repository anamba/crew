defmodule CrewWeb.SignupController do
  use CrewWeb, :controller

  alias Crew.Repo
  alias Crew.Activities.Activity
  alias Crew.Persons.Person
  alias Crew.Signups
  alias Crew.Signups.Signup
  alias Crew.TimeSlots.TimeSlot

  @headers [
    gettext("Time Slot"),
    gettext("Activity"),
    # gettext("Location") ,
    # gettext("Person") ,
    "Start Time",
    "End Time",
    "Time Zone",
    "Name",
    "Prefix",
    "First Name",
    "Middle Name(s)",
    "Last Name",
    "Suffix",
    "Preferred Name",
    "Preferred Pronouns",
    "Email",
    "Phone 1",
    "Phone 1 Type",
    "Phone 2",
    "Phone 2 Type",
    "Adult?",
    "Virtual?",
    "Group?",
    "Original ID",
    "Original Name",
    "Tags",
    "Relationships"
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

  defp signup_to_csv_row(%Signup{} = signup) do
    time_slot = signup.time_slot || %TimeSlot{}
    activity = signup.activity || %Activity{}
    guest = signup.guest || %Person{}

    %{
      gettext("Time Slot") => time_slot.name,
      gettext("Activity") => activity.name,
      # gettext("Location") => location.name,
      # gettext("Person") => person.name,
      "Start Time" => signup.start_time_local,
      "End Time" => signup.end_time_local,
      "Time Zone" => signup.time_zone,
      "Name" => guest.name,
      "Prefix" => guest.prefix,
      "First Name" => guest.first_name,
      "Middle Name(s)" => guest.middle_names,
      "Last Name" => guest.last_name,
      "Suffix" => guest.suffix,
      "Preferred Name" => guest.preferred_name,
      "Preferred Pronouns" => guest.preferred_pronouns,
      "Email" => guest.email,
      "Phone 1" => guest.phone1,
      "Phone 1 Type" => guest.phone1_type,
      "Phone 2" => guest.phone2,
      "Phone 2 Type" => guest.phone2_type,
      "Adult?" => if(guest.adult, do: "Yes", else: "No"),
      "Virtual?" => if(guest.virtual, do: "Yes", else: "No"),
      "Group?" => if(guest.group, do: "Yes", else: "No"),
      "Original ID" => guest.extid,
      "Original Name" => guest.original_name,
      "Tags" => person_taggings_to_str(guest.taggings),
      "Relationships" => person_rels_to_str(guest.out_rels, guest.in_rels)
    }
  end

  defp person_taggings_to_str(taggings) do
    taggings
    |> Enum.map(fn tagging ->
      "#{tagging.tag.name}" <>
        cond do
          tagging.tag.has_value -> ": #{tagging.value}"
          tagging.tag.has_value_i -> ": #{tagging.value_i}"
          true -> ""
        end
    end)
    |> Enum.join(", ")
  end

  defp person_rels_to_str(out_rels, in_rels) do
    ((out_rels
      |> Enum.map(&"#{&1.dest_person.name} (#{&1.dest_label})")) ++
       (in_rels
        |> Enum.map(&"#{&1.src_person.name} (#{&1.src_label})")))
    |> Enum.join(", ")
  end
end
