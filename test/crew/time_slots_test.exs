defmodule Crew.TimeSlotsTest do
  use Crew.DataCase

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

  describe "time_slots" do
    alias Crew.TimeSlots.TimeSlot

    @valid_attrs %{
      start_time: "2020-11-29T15:30:00Z",
      end_time: "2020-11-29T18:10:00Z",
      time_zone: "Asia/Seoul"
    }
    @update_attrs %{end_time: "2020-11-29T18:40:00Z"}
    @invalid_attrs %{start_time: "2020-11-29T18:10:00Z", end_time: "2020-11-29T15:30:00Z"}

    def time_slot_fixture(attrs \\ %{}, site_id) do
      {:ok, time_slot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TimeSlots.create_time_slot(site_id)

      Crew.Repo.preload(time_slot, [:activity, :person, :location, :activity_tag, :person_tag])
    end

    test "list_time_slots/0 returns all time_slots" do
      site_id = site_fixture().id

      time_slot = time_slot_fixture(site_id)

      assert TimeSlots.list_time_slots(site_id) == [time_slot]
    end

    test "get_time_slot!/1 returns the time_slot with given id" do
      time_slot = time_slot_fixture(site_fixture().id)
      assert TimeSlots.get_time_slot!(time_slot.id) == time_slot
    end

    test "create_time_slot/1 with valid data creates a time_slot" do
      assert {:ok, %TimeSlot{} = time_slot} =
               TimeSlots.create_time_slot(@valid_attrs, site_fixture().id)

      assert time_slot.start_time == ~U[2020-11-29 15:30:00Z]
      assert time_slot.end_time == ~U[2020-11-29 18:10:00Z]
    end

    test "create_time_slot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeSlots.create_time_slot(@invalid_attrs)
    end

    test "update_time_slot/2 with valid data updates the time_slot" do
      time_slot = time_slot_fixture(site_fixture().id)

      assert {:ok, %TimeSlot{} = time_slot} = TimeSlots.update_time_slot(time_slot, @update_attrs)

      assert time_slot.end_time == ~U[2020-11-29 18:40:00Z]
    end

    test "update_time_slot/2 with invalid data returns error changeset" do
      time_slot = time_slot_fixture(site_fixture().id)

      assert {:error, %Ecto.Changeset{}} = TimeSlots.update_time_slot(time_slot, @invalid_attrs)

      assert time_slot == TimeSlots.get_time_slot!(time_slot.id)
    end

    test "delete_time_slot/1 deletes the time_slot" do
      time_slot = time_slot_fixture(site_fixture().id)
      assert {:ok, %TimeSlot{}} = TimeSlots.delete_time_slot(time_slot)
      assert_raise Ecto.NoResultsError, fn -> TimeSlots.get_time_slot!(time_slot.id) end
    end

    test "change_time_slot/1 returns a time_slot changeset" do
      time_slot = time_slot_fixture(site_fixture().id)
      assert %Ecto.Changeset{} = TimeSlots.change_time_slot(time_slot)
    end
  end
end
