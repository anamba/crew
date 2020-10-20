# defmodule CrewWeb.LocationLiveTest do
#   use CrewWeb.ConnCase

#   import Phoenix.LiveViewTest

#   alias Crew.Locations

#   @create_attrs %{address1: "some address1", address2: "some address2", address3: "some address3", capacity: 42, city: "some city", country: "some country", description: "some description", latitude: "120.5", longitude: "120.5", name: "some name", postal_code: "some postal_code", slug: "some slug", state: "some state"}
#   @update_attrs %{address1: "some updated address1", address2: "some updated address2", address3: "some updated address3", capacity: 43, city: "some updated city", country: "some updated country", description: "some updated description", latitude: "456.7", longitude: "456.7", name: "some updated name", postal_code: "some updated postal_code", slug: "some updated slug", state: "some updated state"}
#   @invalid_attrs %{address1: nil, address2: nil, address3: nil, capacity: nil, city: nil, country: nil, description: nil, latitude: nil, longitude: nil, name: nil, postal_code: nil, slug: nil, state: nil}

#   defp fixture(:location) do
#     {:ok, location} = Locations.create_location(@create_attrs)
#     location
#   end

#   defp create_location(_) do
#     location = fixture(:location)
#     %{location: location}
#   end

#   describe "Index" do
#     setup [:create_location]

#     test "lists all locations", %{conn: conn, location: location} do
#       {:ok, _index_live, html} = live(conn, Routes.location_index_path(conn, :index))

#       assert html =~ "Listing Locations"
#       assert html =~ location.address1
#     end

#     test "saves new location", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, Routes.location_index_path(conn, :index))

#       assert index_live |> element("a", "New Location") |> render_click() =~
#                "New Location"

#       assert_patch(index_live, Routes.location_index_path(conn, :new))

#       assert index_live
#              |> form("#location-form", location: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#location-form", location: @create_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.location_index_path(conn, :index))

#       assert html =~ "Location created successfully"
#       assert html =~ "some address1"
#     end

#     test "updates location in listing", %{conn: conn, location: location} do
#       {:ok, index_live, _html} = live(conn, Routes.location_index_path(conn, :index))

#       assert index_live |> element("#location-#{location.id} a", "Edit") |> render_click() =~
#                "Edit Location"

#       assert_patch(index_live, Routes.location_index_path(conn, :edit, location))

#       assert index_live
#              |> form("#location-form", location: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#location-form", location: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.location_index_path(conn, :index))

#       assert html =~ "Location updated successfully"
#       assert html =~ "some updated address1"
#     end

#     test "deletes location in listing", %{conn: conn, location: location} do
#       {:ok, index_live, _html} = live(conn, Routes.location_index_path(conn, :index))

#       assert index_live |> element("#location-#{location.id} a", "Delete") |> render_click()
#       refute has_element?(index_live, "#location-#{location.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_location]

#     test "displays location", %{conn: conn, location: location} do
#       {:ok, _show_live, html} = live(conn, Routes.location_show_path(conn, :show, location))

#       assert html =~ "Show Location"
#       assert html =~ location.address1
#     end

#     test "updates location within modal", %{conn: conn, location: location} do
#       {:ok, show_live, _html} = live(conn, Routes.location_show_path(conn, :show, location))

#       assert show_live |> element("a", "Edit") |> render_click() =~
#                "Edit Location"

#       assert_patch(show_live, Routes.location_show_path(conn, :edit, location))

#       assert show_live
#              |> form("#location-form", location: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         show_live
#         |> form("#location-form", location: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.location_show_path(conn, :show, location))

#       assert html =~ "Location updated successfully"
#       assert html =~ "some updated address1"
#     end
#   end
# end
