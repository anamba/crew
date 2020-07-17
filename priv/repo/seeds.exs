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

alias Crew.Repo
alias Crew.Sites.Site

fair = %Site{name: "School Fair", slug: "fair"}
Repo.insert!(fair)

# dual-use: appointments and work shifts
hair = %Site{name: "Hair Shop", slug: "hair"}
Repo.insert!(hair)

chair = %Site{name: "Hot Desk Reservations", slug: "chair"}
Repo.insert!(chair)

care = %Site{name: "Doctor's Office", slug: "care"}
Repo.insert!(care)

ware = %Site{name: "Sales Calendar", slug: "ware"}
Repo.insert!(ware)

share = %Site{name: "Bike Share", slug: "share"}
Repo.insert!(share)

beer = %Site{name: "Sunday Beer League", slug: "beer"}
Repo.insert!(beer)
