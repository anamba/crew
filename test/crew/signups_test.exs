defmodule Crew.SignupsTest do
  use Crew.DataCase

  alias Crew.Persons
  alias Crew.Repo
  alias Crew.Signups
  alias Crew.Sites
  alias Crew.TimeSlots

  @valid_site_attrs %{name: "School Fair", slug: "fair", primary_domain: "fair.example.com"}

  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(@valid_site_attrs)
      |> Sites.create_site()

    site
  end

  @valid_time_slot_attrs %{
    start_time: "2020-11-29T15:30:00Z",
    end_time: "2020-11-29T18:10:00Z",
    time_zone: "Asia/Seoul"
  }

  def time_slot_fixture(attrs \\ %{}, site_id) do
    {:ok, time_slot} =
      attrs
      |> Enum.into(@valid_time_slot_attrs)
      |> TimeSlots.create_time_slot(site_id)

    Repo.preload(time_slot, [:activity, :person, :location, :activity_tag, :person_tag])
  end

  @valid_person_attrs %{
    first_name: "First",
    last_name: "Last"
  }

  def person_fixture(attrs \\ %{}, site_id) do
    {:ok, person} =
      attrs
      |> Enum.into(@valid_person_attrs)
      |> Persons.create_person(site_id)

    person
  end

  describe "signups" do
    alias Crew.Signups.Signup

    @valid_attrs %{
      guest_count: 2
    }
    @update_attrs %{
      guest_count: 3
    }
    @invalid_attrs %{time_slot_id: nil}

    def signup_fixture(attrs \\ %{}, site_id) do
      {:ok, signup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:time_slot_id, time_slot_fixture(site_id).id)
        |> Map.put(:guest_id, person_fixture(site_id).id)
        |> Signups.create_signup(site_id)

      signup
    end

    test "list_signups/0 returns all signups" do
      site_id = site_fixture().id
      signup = signup_fixture(site_id)
      assert Signups.list_signups(site_id) == [signup]
    end

    test "get_signup!/1 returns the signup with given id" do
      signup = signup_fixture(site_fixture().id)
      assert Signups.get_signup!(signup.id) == signup
    end

    test "create_signup/1 with valid data creates a signup" do
      site_id = site_fixture().id

      attrs =
        @valid_attrs
        |> Map.put(:time_slot_id, time_slot_fixture(site_id).id)
        |> Map.put(:guest_id, person_fixture(site_id).id)

      assert {:ok, %Signup{} = signup} = Signups.create_signup(attrs, site_id)
      assert signup.start_time == ~U[2020-11-29T15:30:00Z]
      assert signup.end_time == ~U[2020-11-29T18:10:00Z]
      assert signup.guest_count == 2
    end

    test "create_signup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Signups.create_signup(@invalid_attrs, site_fixture().id)
    end

    test "update_signup/2 with valid data updates the signup" do
      signup = signup_fixture(site_fixture().id)
      assert {:ok, %Signup{} = signup} = Signups.update_signup(signup, @update_attrs)
      assert signup.guest_count == 3
    end

    test "update_signup/2 with invalid data returns error changeset" do
      signup = signup_fixture(site_fixture().id)
      assert {:error, %Ecto.Changeset{}} = Signups.update_signup(signup, @invalid_attrs)
      assert signup == Signups.get_signup!(signup.id)
    end

    test "delete_signup/1 deletes the signup" do
      signup = signup_fixture(site_fixture().id)
      assert {:ok, %Signup{}} = Signups.delete_signup(signup)
      assert_raise Ecto.NoResultsError, fn -> Signups.get_signup!(signup.id) end
    end

    test "change_signup/1 returns a signup changeset" do
      signup = signup_fixture(site_fixture().id)
      assert %Ecto.Changeset{} = Signups.change_signup(signup)
    end
  end
end
