defmodule Crew.ActivitiesTest do
  use Crew.DataCase

  alias Crew.Activities
  alias Crew.Sites

  @valid_site_attrs %{name: "School Fair", slug: "fair", primary_domain: "fair.example.com"}

  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(@valid_site_attrs)
      |> Sites.create_site()

    site
  end

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

    def activity_fixture(attrs \\ %{}, site_id) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity(site_id)

      activity
    end

    test "list_activities/0 returns all activities" do
      site_id = site_fixture().id
      activity = activity_fixture(site_id)
      assert Activities.list_activities(site_id) == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      site_id = site_fixture().id
      activity = activity_fixture(site_id)
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} =
               Activities.create_activity(@valid_attrs, site_fixture().id)

      assert activity.description == "some description"
      assert activity.max_duration_minutes == 42
      assert activity.min_duration_minutes == 42
      assert activity.name == "some name"
      assert activity.slug == "some slug"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Activities.create_activity(@invalid_attrs, site_fixture().id)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture(site_fixture().id)
      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, @update_attrs)
      assert activity.description == "some updated description"
      assert activity.max_duration_minutes == 43
      assert activity.min_duration_minutes == 43
      assert activity.name == "some updated name"
      assert activity.slug == "some updated slug"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture(site_fixture().id)
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture(site_fixture().id)
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture(site_fixture().id)
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end

  describe "activity_tags" do
    alias Crew.Activities.ActivityTag

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def activity_tag_fixture(attrs \\ %{}, site_id) do
      {:ok, activity_tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_tag(site_id)

      activity_tag
    end

    test "list_activity_tags/0 returns all activity_tags" do
      site_id = site_fixture().id
      activity_tag = activity_tag_fixture(site_id)
      assert Activities.list_activity_tags(site_id) == [activity_tag]
    end

    test "get_activity_tag!/1 returns the activity_tag with given id" do
      activity_tag = activity_tag_fixture(site_fixture().id)
      assert Activities.get_activity_tag!(activity_tag.id) == activity_tag
    end

    test "create_activity_tag/1 with valid data creates a activity_tag" do
      assert {:ok, %ActivityTag{} = activity_tag} =
               Activities.create_activity_tag(@valid_attrs, site_fixture().id)

      assert activity_tag.description == "some description"
      assert activity_tag.name == "some name"
    end

    test "create_activity_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Activities.create_activity_tag(@invalid_attrs, site_fixture().id)
    end

    test "update_activity_tag/2 with valid data updates the activity_tag" do
      activity_tag = activity_tag_fixture(site_fixture().id)

      assert {:ok, %ActivityTag{} = activity_tag} =
               Activities.update_activity_tag(activity_tag, @update_attrs)

      assert activity_tag.description == "some updated description"
      assert activity_tag.name == "some updated name"
    end

    test "update_activity_tag/2 with invalid data returns error changeset" do
      activity_tag = activity_tag_fixture(site_fixture().id)

      assert {:error, %Ecto.Changeset{}} =
               Activities.update_activity_tag(activity_tag, @invalid_attrs)

      assert activity_tag == Activities.get_activity_tag!(activity_tag.id)
    end

    test "delete_activity_tag/1 deletes the activity_tag" do
      activity_tag = activity_tag_fixture(site_fixture().id)
      assert {:ok, %ActivityTag{}} = Activities.delete_activity_tag(activity_tag)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity_tag!(activity_tag.id) end
    end

    test "change_activity_tag/1 returns a activity_tag changeset" do
      activity_tag = activity_tag_fixture(site_fixture().id)
      assert %Ecto.Changeset{} = Activities.change_activity_tag(activity_tag)
    end
  end

  describe "activity_tag_groups" do
    alias Crew.Activities.ActivityTagGroup

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def activity_tag_group_fixture(attrs \\ %{}, site_id) do
      {:ok, activity_tag_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity_tag_group(site_id)

      activity_tag_group
    end

    test "list_activity_tag_groups/0 returns all activity_tag_groups" do
      site_id = site_fixture().id
      activity_tag_group = activity_tag_group_fixture(site_id)
      assert Activities.list_activity_tag_groups(site_id) == [activity_tag_group]
    end

    test "get_activity_tag_group!/1 returns the activity_tag_group with given id" do
      activity_tag_group = activity_tag_group_fixture(site_fixture().id)
      assert Activities.get_activity_tag_group!(activity_tag_group.id) == activity_tag_group
    end

    test "create_activity_tag_group/1 with valid data creates a activity_tag_group" do
      assert {:ok, %ActivityTagGroup{} = activity_tag_group} =
               Activities.create_activity_tag_group(@valid_attrs, site_fixture().id)

      assert activity_tag_group.description == "some description"
      assert activity_tag_group.name == "some name"
    end

    test "create_activity_tag_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Activities.create_activity_tag_group(@invalid_attrs, site_fixture().id)
    end

    test "update_activity_tag_group/2 with valid data updates the activity_tag_group" do
      activity_tag_group = activity_tag_group_fixture(site_fixture().id)

      assert {:ok, %ActivityTagGroup{} = activity_tag_group} =
               Activities.update_activity_tag_group(activity_tag_group, @update_attrs)

      assert activity_tag_group.description == "some updated description"
      assert activity_tag_group.name == "some updated name"
    end

    test "update_activity_tag_group/2 with invalid data returns error changeset" do
      activity_tag_group = activity_tag_group_fixture(site_fixture().id)

      assert {:error, %Ecto.Changeset{}} =
               Activities.update_activity_tag_group(activity_tag_group, @invalid_attrs)

      assert activity_tag_group == Activities.get_activity_tag_group!(activity_tag_group.id)
    end

    test "delete_activity_tag_group/1 deletes the activity_tag_group" do
      activity_tag_group = activity_tag_group_fixture(site_fixture().id)
      assert {:ok, %ActivityTagGroup{}} = Activities.delete_activity_tag_group(activity_tag_group)

      assert_raise Ecto.NoResultsError, fn ->
        Activities.get_activity_tag_group!(activity_tag_group.id)
      end
    end

    test "change_activity_tag_group/1 returns a activity_tag_group changeset" do
      activity_tag_group = activity_tag_group_fixture(site_fixture().id)
      assert %Ecto.Changeset{} = Activities.change_activity_tag_group(activity_tag_group)
    end
  end
end
