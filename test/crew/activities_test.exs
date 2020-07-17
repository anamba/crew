defmodule Crew.ActivitiesTest do
  use Crew.DataCase

  alias Crew.Activities

  describe "activities" do
    alias Crew.Activities.Activity

    @valid_attrs %{description: "some description", max_duration_minutes: 42, min_duration_minutes: 42, name: "some name", slug: "some slug"}
    @update_attrs %{description: "some updated description", max_duration_minutes: 43, min_duration_minutes: 43, name: "some updated name", slug: "some updated slug"}
    @invalid_attrs %{description: nil, max_duration_minutes: nil, min_duration_minutes: nil, name: nil, slug: nil}

    def activity_fixture(attrs \\ %{}) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} = Activities.create_activity(@valid_attrs)
      assert activity.description == "some description"
      assert activity.max_duration_minutes == 42
      assert activity.min_duration_minutes == 42
      assert activity.name == "some name"
      assert activity.slug == "some slug"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, @update_attrs)
      assert activity.description == "some updated description"
      assert activity.max_duration_minutes == 43
      assert activity.min_duration_minutes == 43
      assert activity.name == "some updated name"
      assert activity.slug == "some updated slug"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end

  describe "activity_tags" do
    alias Crew.Activities.ActivityTag

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def activity_tag_fixture(attrs \\ %{}) do
      {:ok, activity_tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_tag()

      activity_tag
    end

    test "list_activity_tags/0 returns all activity_tags" do
      activity_tag = activity_tag_fixture()
      assert Activities.list_activity_tags() == [activity_tag]
    end

    test "get_activity_tag!/1 returns the activity_tag with given id" do
      activity_tag = activity_tag_fixture()
      assert Activities.get_activity_tag!(activity_tag.id) == activity_tag
    end

    test "create_activity_tag/1 with valid data creates a activity_tag" do
      assert {:ok, %ActivityTag{} = activity_tag} = Activities.create_activity_tag(@valid_attrs)
      assert activity_tag.description == "some description"
      assert activity_tag.name == "some name"
    end

    test "create_activity_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_tag(@invalid_attrs)
    end

    test "update_activity_tag/2 with valid data updates the activity_tag" do
      activity_tag = activity_tag_fixture()
      assert {:ok, %ActivityTag{} = activity_tag} = Activities.update_activity_tag(activity_tag, @update_attrs)
      assert activity_tag.description == "some updated description"
      assert activity_tag.name == "some updated name"
    end

    test "update_activity_tag/2 with invalid data returns error changeset" do
      activity_tag = activity_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity_tag(activity_tag, @invalid_attrs)
      assert activity_tag == Activities.get_activity_tag!(activity_tag.id)
    end

    test "delete_activity_tag/1 deletes the activity_tag" do
      activity_tag = activity_tag_fixture()
      assert {:ok, %ActivityTag{}} = Activities.delete_activity_tag(activity_tag)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity_tag!(activity_tag.id) end
    end

    test "change_activity_tag/1 returns a activity_tag changeset" do
      activity_tag = activity_tag_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_tag(activity_tag)
    end
  end

  describe "activity_tag_groups" do
    alias Crew.Activities.ActivityTagGroup

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def activity_tag_group_fixture(attrs \\ %{}) do
      {:ok, activity_tag_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_tag_group()

      activity_tag_group
    end

    test "list_activity_tag_groups/0 returns all activity_tag_groups" do
      activity_tag_group = activity_tag_group_fixture()
      assert Activities.list_activity_tag_groups() == [activity_tag_group]
    end

    test "get_activity_tag_group!/1 returns the activity_tag_group with given id" do
      activity_tag_group = activity_tag_group_fixture()
      assert Activities.get_activity_tag_group!(activity_tag_group.id) == activity_tag_group
    end

    test "create_activity_tag_group/1 with valid data creates a activity_tag_group" do
      assert {:ok, %ActivityTagGroup{} = activity_tag_group} = Activities.create_activity_tag_group(@valid_attrs)
      assert activity_tag_group.description == "some description"
      assert activity_tag_group.name == "some name"
    end

    test "create_activity_tag_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_tag_group(@invalid_attrs)
    end

    test "update_activity_tag_group/2 with valid data updates the activity_tag_group" do
      activity_tag_group = activity_tag_group_fixture()
      assert {:ok, %ActivityTagGroup{} = activity_tag_group} = Activities.update_activity_tag_group(activity_tag_group, @update_attrs)
      assert activity_tag_group.description == "some updated description"
      assert activity_tag_group.name == "some updated name"
    end

    test "update_activity_tag_group/2 with invalid data returns error changeset" do
      activity_tag_group = activity_tag_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity_tag_group(activity_tag_group, @invalid_attrs)
      assert activity_tag_group == Activities.get_activity_tag_group!(activity_tag_group.id)
    end

    test "delete_activity_tag_group/1 deletes the activity_tag_group" do
      activity_tag_group = activity_tag_group_fixture()
      assert {:ok, %ActivityTagGroup{}} = Activities.delete_activity_tag_group(activity_tag_group)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity_tag_group!(activity_tag_group.id) end
    end

    test "change_activity_tag_group/1 returns a activity_tag_group changeset" do
      activity_tag_group = activity_tag_group_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_tag_group(activity_tag_group)
    end
  end

  describe "activity_slots" do
    alias Crew.Activities.ActivitySlot

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def activity_slot_fixture(attrs \\ %{}) do
      {:ok, activity_slot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_slot()

      activity_slot
    end

    test "list_activity_slots/0 returns all activity_slots" do
      activity_slot = activity_slot_fixture()
      assert Activities.list_activity_slots() == [activity_slot]
    end

    test "get_activity_slot!/1 returns the activity_slot with given id" do
      activity_slot = activity_slot_fixture()
      assert Activities.get_activity_slot!(activity_slot.id) == activity_slot
    end

    test "create_activity_slot/1 with valid data creates a activity_slot" do
      assert {:ok, %ActivitySlot{} = activity_slot} = Activities.create_activity_slot(@valid_attrs)
      assert activity_slot.description == "some description"
      assert activity_slot.name == "some name"
    end

    test "create_activity_slot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_slot(@invalid_attrs)
    end

    test "update_activity_slot/2 with valid data updates the activity_slot" do
      activity_slot = activity_slot_fixture()
      assert {:ok, %ActivitySlot{} = activity_slot} = Activities.update_activity_slot(activity_slot, @update_attrs)
      assert activity_slot.description == "some updated description"
      assert activity_slot.name == "some updated name"
    end

    test "update_activity_slot/2 with invalid data returns error changeset" do
      activity_slot = activity_slot_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity_slot(activity_slot, @invalid_attrs)
      assert activity_slot == Activities.get_activity_slot!(activity_slot.id)
    end

    test "delete_activity_slot/1 deletes the activity_slot" do
      activity_slot = activity_slot_fixture()
      assert {:ok, %ActivitySlot{}} = Activities.delete_activity_slot(activity_slot)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity_slot!(activity_slot.id) end
    end

    test "change_activity_slot/1 returns a activity_slot changeset" do
      activity_slot = activity_slot_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_slot(activity_slot)
    end
  end

  describe "activity_slot_requirements" do
    alias Crew.Activities.ActivitySlotRequirement

    @valid_attrs %{description: "some description", location_gap_after_minutes: 42, location_gap_before_minutes: 42, name: "some name", option_group: 42, person_gap_after_minutes: 42, person_gap_before_minutes: 42, start_time: ~T[14:00:00]}
    @update_attrs %{description: "some updated description", location_gap_after_minutes: 43, location_gap_before_minutes: 43, name: "some updated name", option_group: 43, person_gap_after_minutes: 43, person_gap_before_minutes: 43, start_time: ~T[15:01:01]}
    @invalid_attrs %{description: nil, location_gap_after_minutes: nil, location_gap_before_minutes: nil, name: nil, option_group: nil, person_gap_after_minutes: nil, person_gap_before_minutes: nil, start_time: nil}

    def activity_slot_requirement_fixture(attrs \\ %{}) do
      {:ok, activity_slot_requirement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_slot_requirement()

      activity_slot_requirement
    end

    test "list_activity_slot_requirements/0 returns all activity_slot_requirements" do
      activity_slot_requirement = activity_slot_requirement_fixture()
      assert Activities.list_activity_slot_requirements() == [activity_slot_requirement]
    end

    test "get_activity_slot_requirement!/1 returns the activity_slot_requirement with given id" do
      activity_slot_requirement = activity_slot_requirement_fixture()
      assert Activities.get_activity_slot_requirement!(activity_slot_requirement.id) == activity_slot_requirement
    end

    test "create_activity_slot_requirement/1 with valid data creates a activity_slot_requirement" do
      assert {:ok, %ActivitySlotRequirement{} = activity_slot_requirement} = Activities.create_activity_slot_requirement(@valid_attrs)
      assert activity_slot_requirement.description == "some description"
      assert activity_slot_requirement.location_gap_after_minutes == 42
      assert activity_slot_requirement.location_gap_before_minutes == 42
      assert activity_slot_requirement.name == "some name"
      assert activity_slot_requirement.option_group == 42
      assert activity_slot_requirement.person_gap_after_minutes == 42
      assert activity_slot_requirement.person_gap_before_minutes == 42
      assert activity_slot_requirement.start_time == ~T[14:00:00]
    end

    test "create_activity_slot_requirement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_slot_requirement(@invalid_attrs)
    end

    test "update_activity_slot_requirement/2 with valid data updates the activity_slot_requirement" do
      activity_slot_requirement = activity_slot_requirement_fixture()
      assert {:ok, %ActivitySlotRequirement{} = activity_slot_requirement} = Activities.update_activity_slot_requirement(activity_slot_requirement, @update_attrs)
      assert activity_slot_requirement.description == "some updated description"
      assert activity_slot_requirement.location_gap_after_minutes == 43
      assert activity_slot_requirement.location_gap_before_minutes == 43
      assert activity_slot_requirement.name == "some updated name"
      assert activity_slot_requirement.option_group == 43
      assert activity_slot_requirement.person_gap_after_minutes == 43
      assert activity_slot_requirement.person_gap_before_minutes == 43
      assert activity_slot_requirement.start_time == ~T[15:01:01]
    end

    test "update_activity_slot_requirement/2 with invalid data returns error changeset" do
      activity_slot_requirement = activity_slot_requirement_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity_slot_requirement(activity_slot_requirement, @invalid_attrs)
      assert activity_slot_requirement == Activities.get_activity_slot_requirement!(activity_slot_requirement.id)
    end

    test "delete_activity_slot_requirement/1 deletes the activity_slot_requirement" do
      activity_slot_requirement = activity_slot_requirement_fixture()
      assert {:ok, %ActivitySlotRequirement{}} = Activities.delete_activity_slot_requirement(activity_slot_requirement)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity_slot_requirement!(activity_slot_requirement.id) end
    end

    test "change_activity_slot_requirement/1 returns a activity_slot_requirement changeset" do
      activity_slot_requirement = activity_slot_requirement_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_slot_requirement(activity_slot_requirement)
    end
  end
end
