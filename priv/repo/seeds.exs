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
  case Sites.get_site_by(slug: "fair") do
    nil -> Sites.create_site(%{name: "School Fair", slug: "fair"})
    existing -> {:ok, existing}
  end

{:ok, _site_member} = Sites.get_or_create_site_member(fair.id, admin.id, %{role: "owner"})

{:ok, _location} =
  case Locations.get_location_by(%{slug: "school"}, fair.id) do
    nil -> Locations.create_location(%{name: "The School", slug: "school"}, fair.id)
    existing -> {:ok, existing}
  end

pg_attrs = %{name: "Fair 2021", slug: "fair-2021", event: true}

{:ok, period_group} =
  case Periods.get_period_group_by(%{slug: "fair-2021"}, fair.id) do
    nil -> Periods.create_period_group(pg_attrs, fair.id)
    existing -> {:ok, existing}
  end

p1_attrs = %{
  name: "Fair 2021 Day 1",
  slug: "fair-2021-day1",
  start_time: ~U[2021-04-16 21:00:00Z],
  end_time: ~U[2021-04-17 07:00:00Z],
  period_group_id: period_group.id
}

p2_attrs = %{
  name: "Fair 2021 Day 2",
  slug: "fair-2021-day2",
  start_time: ~U[2021-04-17 21:00:00Z],
  end_time: ~U[2021-04-18 07:00:00Z],
  period_group_id: period_group.id
}

{:ok, _day1} =
  case Periods.get_period_by(%{slug: "fair-2021-day1"}, fair.id) do
    nil -> Periods.create_period(p1_attrs, fair.id)
    existing -> {:ok, existing}
  end

{:ok, _day2} =
  case Periods.get_period_by(%{slug: "fair-2021-day2"}, fair.id) do
    nil -> Periods.create_period(p2_attrs, fair.id)
    existing -> {:ok, existing}
  end

for ptag <- ["Alum", "Current Student", "Current Parent", "Current Faculty/Staff"] do
  {:ok, _} =
    case Persons.get_person_tag_by(%{name: ptag}, fair.id) do
      nil -> Persons.create_person_tag(%{name: ptag}, fair.id)
      existing -> {:ok, existing}
    end
end

# TODO: create an example activity + 1 slot w/requirements

for atag <- ["Alums Only", "Parents Only", "Faculty/Staff Only"] do
  {:ok, _} =
    case Activities.get_activity_tag_by(%{name: atag}, fair.id) do
      nil -> Activities.create_activity_tag(%{name: atag}, fair.id)
      existing -> {:ok, existing}
    end
end

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
