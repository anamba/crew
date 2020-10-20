# defmodule Crew.LocationsTest do
#   use Crew.DataCase

#   alias Crew.Locations

#   describe "locations" do
#     alias Crew.Locations.Location

#     @valid_attrs %{address1: "some address1", address2: "some address2", address3: "some address3", capacity: 42, city: "some city", country: "some country", description: "some description", latitude: "120.5", longitude: "120.5", name: "some name", postal_code: "some postal_code", slug: "some slug", state: "some state"}
#     @update_attrs %{address1: "some updated address1", address2: "some updated address2", address3: "some updated address3", capacity: 43, city: "some updated city", country: "some updated country", description: "some updated description", latitude: "456.7", longitude: "456.7", name: "some updated name", postal_code: "some updated postal_code", slug: "some updated slug", state: "some updated state"}
#     @invalid_attrs %{address1: nil, address2: nil, address3: nil, capacity: nil, city: nil, country: nil, description: nil, latitude: nil, longitude: nil, name: nil, postal_code: nil, slug: nil, state: nil}

#     def location_fixture(attrs \\ %{}) do
#       {:ok, location} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Locations.create_location()

#       location
#     end

#     test "list_locations/0 returns all locations" do
#       location = location_fixture()
#       assert Locations.list_locations() == [location]
#     end

#     test "get_location!/1 returns the location with given id" do
#       location = location_fixture()
#       assert Locations.get_location!(location.id) == location
#     end

#     test "create_location/1 with valid data creates a location" do
#       assert {:ok, %Location{} = location} = Locations.create_location(@valid_attrs)
#       assert location.address1 == "some address1"
#       assert location.address2 == "some address2"
#       assert location.address3 == "some address3"
#       assert location.capacity == 42
#       assert location.city == "some city"
#       assert location.country == "some country"
#       assert location.description == "some description"
#       assert location.latitude == Decimal.new("120.5")
#       assert location.longitude == Decimal.new("120.5")
#       assert location.name == "some name"
#       assert location.postal_code == "some postal_code"
#       assert location.slug == "some slug"
#       assert location.state == "some state"
#     end

#     test "create_location/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Locations.create_location(@invalid_attrs)
#     end

#     test "update_location/2 with valid data updates the location" do
#       location = location_fixture()
#       assert {:ok, %Location{} = location} = Locations.update_location(location, @update_attrs)
#       assert location.address1 == "some updated address1"
#       assert location.address2 == "some updated address2"
#       assert location.address3 == "some updated address3"
#       assert location.capacity == 43
#       assert location.city == "some updated city"
#       assert location.country == "some updated country"
#       assert location.description == "some updated description"
#       assert location.latitude == Decimal.new("456.7")
#       assert location.longitude == Decimal.new("456.7")
#       assert location.name == "some updated name"
#       assert location.postal_code == "some updated postal_code"
#       assert location.slug == "some updated slug"
#       assert location.state == "some updated state"
#     end

#     test "update_location/2 with invalid data returns error changeset" do
#       location = location_fixture()
#       assert {:error, %Ecto.Changeset{}} = Locations.update_location(location, @invalid_attrs)
#       assert location == Locations.get_location!(location.id)
#     end

#     test "delete_location/1 deletes the location" do
#       location = location_fixture()
#       assert {:ok, %Location{}} = Locations.delete_location(location)
#       assert_raise Ecto.NoResultsError, fn -> Locations.get_location!(location.id) end
#     end

#     test "change_location/1 returns a location changeset" do
#       location = location_fixture()
#       assert %Ecto.Changeset{} = Locations.change_location(location)
#     end
#   end
# end
