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
alias Crew.Sites

admin_attrs = %{
  name: "Example Admin",
  email: "admin@example.com",
  password: "XHTUfgP7zFy7!4qh3dHjFthG"
}

{:ok, admin} =
  case Accounts.get_user_by_email(admin_attrs[:email]) do
    nil -> Accounts.create_user(admin_attrs)
    existing -> {:ok, existing}
  end

{:ok, fair} =
  Sites.upsert_site(%{slug: "fair"}, %{
    name: "School Fair",
    primary_domain: "crew.lvh.me",
    sender_email: "no-reply@example.com",
    default_time_zone: "Pacific/Honolulu"
  })

{:ok, _site_member} = Sites.upsert_site_member(%{user_id: admin.id}, %{role: "owner"}, fair.id)

{:ok, _location} = Locations.upsert_location(%{slug: "school"}, %{name: "The School"}, fair.id)

attrs = %{name: "Fair 2021", event: true}
{:ok, period_group} = Periods.upsert_period_group(%{slug: "fair-2021"}, attrs, fair.id)

attrs = %{
  name: "Fair 2021 Day 1",
  start_time: ~U[2021-04-09 21:00:00Z],
  end_time: ~U[2021-04-10 07:00:00Z],
  time_zone: "Pacific/Honolulu",
  period_group_id: period_group.id
}

{:ok, day1} = Periods.upsert_period(%{slug: "fair-2021-day1"}, attrs, fair.id)

attrs = %{
  name: "Fair 2021 Day 2",
  start_time: ~U[2021-04-10 21:00:00Z],
  end_time: ~U[2021-04-11 07:00:00Z],
  time_zone: "Pacific/Honolulu",
  period_group_id: period_group.id
}

{:ok, _day2} = Periods.upsert_period(%{slug: "fair-2021-day2"}, attrs, fair.id)

for ptag <- ["Alum", "Current Student", "Current Parent", "Current Faculty/Staff"] do
  {:ok, _} = Persons.upsert_person_tag(%{name: ptag}, %{}, fair.id)
end

# affiliation tag (for people not in db and not alum)
attrs = %{
  use_value: true,
  value_choices_json:
    "['Alumni Spouse','Faculty/Staff Spouse','Current Family Member','Friend of Student','Non-Student','Other Adult']"
}

{:ok, _} = Persons.upsert_person_tag(%{name: "Affiliation"}, attrs, fair.id)

# t-shirt size tag
attrs = %{has_value: true, value_choices_json: "['S','M','L','XL','2XL']"}
{:ok, _} = Persons.upsert_person_tag(%{name: "T-Shirt Size"}, attrs, fair.id)

# grad year tag
attrs = %{has_value_i: true, value_i_min: 1935, value_i_max: 2035}
{:ok, grad_year} = Persons.upsert_person_tag(%{name: "Graduation Year"}, attrs, fair.id)

# example activity 1 for 2031 CPs
{:ok, booth1} =
  Activities.upsert_activity(%{slug: "booth1"}, %{name: "Booth 1 - 2031 Parents"}, fair.id)

# example activity 2 for 1998 alums
{:ok, _booth2} =
  Activities.upsert_activity(%{slug: "booth2"}, %{name: "Booth 2 - 1998 Alums"}, fair.id)

# example activity 3 for F/S only
{:ok, _booth3} = Activities.upsert_activity(%{slug: "booth3"}, %{name: "Booth 3 - F/S"}, fair.id)

shift1_attrs = %{
  start_time: ~U[2021-04-10 21:00:00Z],
  end_time: ~U[2021-04-11 00:00:00Z],
  time_zone: "Pacific/Honolulu"
}

{:ok, _} =
  Activities.upsert_time_slot(
    %{period_id: day1.id, activity_id: booth1.id},
    shift1_attrs,
    fair.id
  )

# TODO: activity tags are more about allowing filtering than creating restrictions; revisit later
# for atag <- ["For Alums", "For Current Parents", "For Faculty/Staff"] do
#   {:ok, _} = Activities.upsert_activity_tag(%{name: atag}, %{}, fair.id)
# end

{:ok, child} = Persons.upsert_person(%{first_name: "Child", last_name: "Test"}, %{}, fair.id)
Persons.tag_person(child, grad_year, %{value_i: 2031})

{:ok, parent} = Persons.upsert_person(%{first_name: "Parent", last_name: "Test"}, %{}, fair.id)
Persons.tag_person(child, grad_year, %{value_i: 1998})
Persons.upsert_person_rel(parent, "Parent", "Child", child, %{})

{:ok, _faculty} = Persons.upsert_person(%{first_name: "Faculty", last_name: "Test"}, %{}, fair.id)
Persons.tag_person(child, grad_year, %{value_i: 1997})

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
