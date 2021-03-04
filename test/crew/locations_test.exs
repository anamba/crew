defmodule Crew.LocationsTest do
  use Crew.DataCase

  alias Crew.Locations
  alias Crew.Sites

  @valid_site_attrs %{name: "School Fair", slug: "fair", primary_domain: "fair.example.com"}

  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(@valid_site_attrs)
      |> Sites.create_site()

    site
  end

  describe "locations" do
    alias Crew.Locations.Location

    @valid_attrs %{
      name: "some name",
      slug: "some slug",
      description: "some description",
      capacity: 42,
      address1: "some address1",
      address2: "some address2",
      address3: "some address3",
      city: "some city",
      state: "some state",
      postal_code: "some postal_code",
      country: "some country"
    }
    @update_attrs %{
      name: "some updated name",
      slug: "some updated slug",
      description: "some updated description",
      capacity: 43,
      address1: "some updated address1",
      address2: "some updated address2",
      address3: "some updated address3",
      city: "some updated city",
      state: "some updated state",
      postal_code: "some updated postal_code",
      country: "some updated country"
    }
    @invalid_attrs %{
      name: nil,
      slug: nil,
      description: nil,
      capacity: nil,
      address1: nil,
      address2: nil,
      address3: nil,
      city: nil,
      state: nil,
      country: nil,
      postal_code: nil
    }

    def location_fixture(attrs \\ %{}, site_id) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Locations.create_location(site_id)

      location
    end

    test "list_locations/0 returns all locations" do
      site_id = site_fixture().id
      location = location_fixture(site_id)
      assert Locations.list_locations(site_id) == [location]
    end

    test "get_location!/1 returns the location with given id" do
      site_id = site_fixture().id
      location = location_fixture(site_id)
      assert Locations.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      site_id = site_fixture().id
      assert {:ok, %Location{} = location} = Locations.create_location(@valid_attrs, site_id)
      assert location.address1 == "some address1"
      assert location.address2 == "some address2"
      assert location.address3 == "some address3"
      assert location.capacity == 42
      assert location.city == "some city"
      assert location.country == "some country"
      assert location.description == "some description"
      assert location.name == "some name"
      assert location.postal_code == "some postal_code"
      assert location.slug == "some slug"
      assert location.state == "some state"
    end

    test "create_location/1 with invalid data returns error changeset" do
      site_id = site_fixture().id
      assert {:error, %Ecto.Changeset{}} = Locations.create_location(@invalid_attrs, site_id)
    end

    test "update_location/2 with valid data updates the location" do
      site_id = site_fixture().id
      location = location_fixture(site_id)
      assert {:ok, %Location{} = location} = Locations.update_location(location, @update_attrs)
      assert location.address1 == "some updated address1"
      assert location.address2 == "some updated address2"
      assert location.address3 == "some updated address3"
      assert location.capacity == 43
      assert location.city == "some updated city"
      assert location.country == "some updated country"
      assert location.description == "some updated description"
      assert location.name == "some updated name"
      assert location.postal_code == "some updated postal_code"
      assert location.slug == "some updated slug"
      assert location.state == "some updated state"
    end

    test "update_location/2 with invalid data returns error changeset" do
      site_id = site_fixture().id
      location = location_fixture(site_id)
      assert {:error, %Ecto.Changeset{}} = Locations.update_location(location, @invalid_attrs)
      assert location == Locations.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      site_id = site_fixture().id
      location = location_fixture(site_id)
      assert {:ok, %Location{}} = Locations.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      site_id = site_fixture().id
      location = location_fixture(site_id)
      assert %Ecto.Changeset{} = Locations.change_location(location)
    end
  end
end
