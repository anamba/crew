defmodule Crew.ActivitiesTest do
  use Crew.DataCase

  alias Crew.Activities

  describe "activities" do
    alias Crew.Activities.Activity

    @valid_attrs %{
      description: "some description",
      max_duration_minutes: 42,
      min_duration_minutes: 42,
      name: "some name",
      slug: "some slug"
    }
    @update_attrs %{
      description: "some updated description",
      max_duration_minutes: 43,
      min_duration_minutes: 43,
      name: "some updated name",
      slug: "some updated slug"
    }
    @invalid_attrs %{
      description: nil,
      max_duration_minutes: nil,
      min_duration_minutes: nil,
      name: nil,
      slug: nil
    }

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

      assert {:ok, %ActivityTag{} = activity_tag} =
               Activities.update_activity_tag(activity_tag, @update_attrs)

      assert activity_tag.description == "some updated description"
      assert activity_tag.name == "some updated name"
    end

    test "update_activity_tag/2 with invalid data returns error changeset" do
      activity_tag = activity_tag_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Activities.update_activity_tag(activity_tag, @invalid_attrs)

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
      assert {:ok, %ActivityTagGroup{} = activity_tag_group} =
               Activities.create_activity_tag_group(@valid_attrs)

      assert activity_tag_group.description == "some description"
      assert activity_tag_group.name == "some name"
    end

    test "create_activity_tag_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_tag_group(@invalid_attrs)
    end

    test "update_activity_tag_group/2 with valid data updates the activity_tag_group" do
      activity_tag_group = activity_tag_group_fixture()

      assert {:ok, %ActivityTagGroup{} = activity_tag_group} =
               Activities.update_activity_tag_group(activity_tag_group, @update_attrs)

      assert activity_tag_group.description == "some updated description"
      assert activity_tag_group.name == "some updated name"
    end

    test "update_activity_tag_group/2 with invalid data returns error changeset" do
      activity_tag_group = activity_tag_group_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Activities.update_activity_tag_group(activity_tag_group, @invalid_attrs)

      assert activity_tag_group == Activities.get_activity_tag_group!(activity_tag_group.id)
    end

    test "delete_activity_tag_group/1 deletes the activity_tag_group" do
      activity_tag_group = activity_tag_group_fixture()
      assert {:ok, %ActivityTagGroup{}} = Activities.delete_activity_tag_group(activity_tag_group)

      assert_raise Ecto.NoResultsError, fn ->
        Activities.get_activity_tag_group!(activity_tag_group.id)
      end
    end

    test "change_activity_tag_group/1 returns a activity_tag_group changeset" do
      activity_tag_group = activity_tag_group_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_tag_group(activity_tag_group)
    end
  end

  describe "time_slots" do
    alias Crew.Activities.TimeSlot

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def time_slot_fixture(attrs \\ %{}) do
      {:ok, time_slot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_time_slot()

      time_slot
    end

    test "list_time_slots/0 returns all time_slots" do
      time_slot = time_slot_fixture()
      assert Activities.list_time_slots() == [time_slot]
    end

    test "get_time_slot!/1 returns the time_slot with given id" do
      time_slot = time_slot_fixture()
      assert Activities.get_time_slot!(time_slot.id) == time_slot
    end

    test "create_time_slot/1 with valid data creates a time_slot" do
      assert {:ok, %TimeSlot{} = time_slot} = Activities.create_time_slot(@valid_attrs)
      assert time_slot.description == "some description"
      assert time_slot.name == "some name"
    end

    test "create_time_slot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_time_slot(@invalid_attrs)
    end

    test "update_time_slot/2 with valid data updates the time_slot" do
      time_slot = time_slot_fixture()

      assert {:ok, %TimeSlot{} = time_slot} =
               Activities.update_time_slot(time_slot, @update_attrs)

      assert time_slot.description == "some updated description"
      assert time_slot.name == "some updated name"
    end

    test "update_time_slot/2 with invalid data returns error changeset" do
      time_slot = time_slot_fixture()

      assert {:error, %Ecto.Changeset{}} = Activities.update_time_slot(time_slot, @invalid_attrs)

      assert time_slot == Activities.get_time_slot!(time_slot.id)
    end

    test "delete_time_slot/1 deletes the time_slot" do
      time_slot = time_slot_fixture()
      assert {:ok, %TimeSlot{}} = Activities.delete_time_slot(time_slot)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_time_slot!(time_slot.id) end
    end

    test "change_time_slot/1 returns a time_slot changeset" do
      time_slot = time_slot_fixture()
      assert %Ecto.Changeset{} = Activities.change_time_slot(time_slot)
    end
  end
end
