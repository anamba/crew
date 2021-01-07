# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Or run `mix ecto.reset` to drop and re-create the database from scratch.
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Crew.Repo.insert!(%Crew.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Crew.Accounts
alias Crew.Activities
alias Crew.Locations
alias Crew.Periods
alias Crew.Persons
alias Crew.Persons.Person
alias Crew.Sites
alias Crew.TimeSlots

# create elasticsearch index
es_url =
  "http://#{Application.get_env(:crew, :elasticsearch_host)}" <>
    ":#{Application.get_env(:crew, :elasticsearch_port)}"

es_index = Application.get_env(:crew, :elasticsearch_index)

if Elastix.Index.exists?(es_url, es_index),
  do: Elastix.Index.delete(es_url, es_index)

# Elastix.Index.create(es_url, es_index, %{})

Elastix.HTTP.put!(
  es_url <> "/#{es_index}",
  Jason.encode!(%{
    settings: %{
      index: %{
        analysis: %{
          analyzer: %{
            keyword_case_insensitive: %{
              tokenizer: "keyword",
              filter: "lowercase"
            }
          }
        }
      }
    }
  })
)

Elastix.Mapping.put(es_url, es_index, "person", %{properties: Person.elasticsearch_mapping()},
  include_type_name: true
)

admin_attrs = %{
  name: "Example Admin",
  email: "admin@example.com",
  password: "XHTUfgP7zFy7!4qh3dHjFthG",
  confirmed_at: Timex.now()
}

{:ok, admin} =
  case Accounts.get_user_by_email(admin_attrs[:email]) do
    nil -> Accounts.create_user(admin_attrs)
    existing -> {:ok, existing}
  end

{:ok, admin} = Accounts.promote_user_to_admin(admin)

attrs = %{
  name: "School Fair",
  primary_domain: "crew.lvh.me",
  sender_email: "no-reply@example.com",
  default_time_zone: "Pacific/Honolulu"
}

{:ok, fair} = Sites.upsert_site(attrs, %{slug: "fair"})

{:ok, _site_member} = Sites.upsert_site_member(%{role: "owner"}, %{user_id: admin.id}, fair.id)

{:ok, _location} = Locations.upsert_location(%{name: "The School"}, %{slug: "school"}, fair.id)

attrs = %{name: "Fair 2021", event: true}
{:ok, period_group} = Periods.upsert_period_group(attrs, %{slug: "fair-2021"}, fair.id)

attrs = %{
  name: "Fair 2021 Day 1",
  start_time_local: ~N[2021-04-09 11:00:00],
  end_time_local: ~N[2021-04-09 21:00:00],
  time_zone: "Pacific/Honolulu",
  period_group_id: period_group.id
}

{:ok, day1} = Periods.upsert_period(attrs, %{slug: "fair-2021-day1"}, fair.id)

attrs = %{
  name: "Fair 2021 Day 2",
  start_time_local: ~N[2021-04-10 11:00:00],
  end_time_local: ~N[2021-04-10 21:00:00],
  time_zone: "Pacific/Honolulu",
  period_group_id: period_group.id
}

{:ok, day2} = Periods.upsert_period(attrs, %{slug: "fair-2021-day2"}, fair.id)

{:ok, tag_adult} = Persons.upsert_person_tag(%{name: "Adult"}, fair.id)
{:ok, _tag_faculty} = Persons.upsert_person_tag(%{name: "Current Faculty/Staff"}, fair.id)
{:ok, _tag_faculty_spouse} = Persons.upsert_person_tag(%{name: "Faculty/Staff Spouse"}, fair.id)

attrs = %{value_label: "Class Year", has_value_i: true, value_i_min: 1900, value_i_max: 2020}
{:ok, tag_alum} = Persons.upsert_person_tag(attrs, %{name: "Alum"}, fair.id)
attrs = %{value_label: "Class Year", has_value_i: true, value_i_min: 2021, value_i_max: 2035}
{:ok, tag_student} = Persons.upsert_person_tag(attrs, %{name: "Current Student"}, fair.id)
attrs = %{value_label: "Class Year", has_value_i: true, value_i_min: 2021, value_i_max: 2035}
{:ok, tag_parent} = Persons.upsert_person_tag(attrs, %{name: "Current Parent"}, fair.id)

# affiliation tag (for people not in db and not alum)
attrs = %{
  has_value: true,
  value_label: "Affiliation",
  value_choices_json: """
  ["Alumni Spouse","Faculty/Staff Spouse","Current Family Member","Friend of Student","Non-Student","Other Adult"]
  """
}

{:ok, _} = Persons.upsert_person_tag(attrs, %{name: "Affiliation"}, fair.id)

# t-shirt size tag
attrs = %{value_label: "Size", has_value: true, value_choices_json: "['S','M','L','XL','2XL']"}
{:ok, _} = Persons.upsert_person_tag(attrs, %{name: "T-Shirt Size"}, fair.id)

# example activity 1 for 2031 CPs
{:ok, booth1} =
  Activities.upsert_activity(%{name: "Booth 1 - 2031 Parents"}, %{slug: "booth1"}, fair.id)

# example activity 2 for 1998 alums
{:ok, _booth2} =
  Activities.upsert_activity(%{name: "Booth 2 - 1998 Alums"}, %{slug: "booth2"}, fair.id)

# example activity 3 for F/S only
{:ok, _booth3} = Activities.upsert_activity(%{name: "Booth 3 - F/S"}, %{slug: "booth3"}, fair.id)

shift1_attrs = %{
  start_time_local: ~N[2021-04-09 12:00:00],
  end_time_local: ~N[2021-04-09 14:30:00],
  time_zone: "Pacific/Honolulu",
  signup_target: 2,
  signup_maximum: 2,
  person_tag_id: tag_adult.id
}

shift2_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-09 14:30:00],
    end_time_local: ~N[2021-04-09 17:00:00]
  })

shift3_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-09 17:00:00],
    end_time_local: ~N[2021-04-09 19:30:00]
  })

shift4_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-09 19:30:00],
    end_time_local: ~N[2021-04-09 21:30:00]
  })

shift1s_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-10 12:00:00],
    end_time_local: ~N[2021-04-10 14:30:00]
  })

shift2s_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-10 14:30:00],
    end_time_local: ~N[2021-04-10 17:00:00]
  })

shift3s_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-10 17:00:00],
    end_time_local: ~N[2021-04-10 19:30:00]
  })

shift4s_attrs =
  Map.merge(shift1_attrs, %{
    start_time_local: ~N[2021-04-10 19:30:00],
    end_time_local: ~N[2021-04-10 21:30:00]
  })

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day1.id, activity_id: booth1.id},
    shift1_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day1.id, activity_id: booth1.id},
    shift2_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day1.id, activity_id: booth1.id},
    shift3_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day1.id, activity_id: booth1.id},
    shift4_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day2.id, activity_id: booth1.id},
    shift1s_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day2.id, activity_id: booth1.id},
    shift2s_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day2.id, activity_id: booth1.id},
    shift3s_attrs,
    fair.id
  )

{:ok, _time_slot} =
  TimeSlots.upsert_time_slot(
    %{period_id: day2.id, activity_id: booth1.id},
    shift4s_attrs,
    fair.id
  )

# TODO: activity tags are more about allowing filtering than creating restrictions; revisit later
# for atag <- ["For Alums", "For Current Parents", "For Faculty/Staff"] do
#   {:ok, _} = Activities.upsert_activity_tag(%{name: atag}, %{}, fair.id)
# end

{:ok, child} = Persons.upsert_person(%{first_name: "Child", last_name: "Test"}, fair.id)
Persons.tag_person(child, tag_student, %{value_i: 2031})

{:ok, parent} = Persons.upsert_person(%{first_name: "Parent", last_name: "Test"}, fair.id)
Persons.tag_person(parent, tag_parent, %{value_i: 1998})
Persons.upsert_person_rel(parent, "Parent", "Child", child)

{:ok, faculty} = Persons.upsert_person(%{first_name: "Faculty", last_name: "Test"}, fair.id)
Persons.tag_person(faculty, tag_alum, %{value_i: 1997})

# dual-use: appointments and work shifts
# hair = %Site{name: "Hair Shop", slug: "hair"}
# Repo.insert!(hair)

# chair = %Site{name: "Hot Desk Reservations", slug: "chair"}
# Repo.insert!(chair)

# care = %Site{name: "Doctor's Office", slug: "care"}
# Repo.insert!(care)

# ware = %Site{name: "Sales Calendar", slug: "ware"}
# Repo.insert!(ware)

# share = %Site{name: "Bike Share", slug: "share"}
# Repo.insert!(share)

# beer = %Site{name: "Sunday Beer League", slug: "beer"}
# Repo.insert!(beer)
