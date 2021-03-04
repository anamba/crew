defmodule Crew.PersonsTest do
  use ExUnit.Case

  doctest Crew.Persons.Person

  use Crew.DataCase

  alias Crew.Persons
  alias Crew.Persons.Person
  alias Crew.Sites

  @valid_site_attrs %{name: "School Fair", slug: "fair", primary_domain: "fair.example.com"}

  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(@valid_site_attrs)
      |> Sites.create_site()

    site
  end

  describe "persons" do
    @valid_attrs %{
      first_name: "some first_name",
      last_name: "some last_name",
      middle_names: "some middle_names",
      note: "some note",
      profile: "some profile",
      suffix: "some suffix",
      prefix: "some prefix"
    }
    @update_attrs %{
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      middle_names: "some updated middle_names",
      note: "some updated note",
      profile: "some updated profile",
      suffix: "some updated suffix",
      prefix: "some updated prefix"
    }
    @invalid_attrs %{
      first_name: nil,
      last_name: nil,
      middle_names: nil,
      note: nil,
      profile: nil,
      suffix: nil,
      prefix: nil
    }

    def person_fixture(attrs \\ %{}, site_id) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Persons.create_person(site_id)

      person
    end

    test "list_persons/0 returns all persons" do
      site_id = site_fixture().id
      person = person_fixture(site_id)
      assert Persons.list_persons(site_id) == [person]
    end

    test "get_person!/1 returns the person with given id" do
      site_id = site_fixture().id
      person = person_fixture(site_id)
      assert Persons.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      site_id = site_fixture().id
      assert {:ok, %Person{} = person} = Persons.create_person(@valid_attrs, site_id)
      assert person.first_name == "some first_name"
      assert person.last_name == "some last_name"
      assert person.middle_names == "some middle_names"
      assert person.note == "some note"
      assert person.profile == "some profile"
      assert person.suffix == "some suffix"
      assert person.prefix == "some prefix"
    end

    test "create_person/1 with invalid data returns error changeset" do
      site_id = site_fixture().id
      assert {:error, %Ecto.Changeset{}} = Persons.create_person(@invalid_attrs, site_id)
    end

    test "update_person/2 with valid data updates the person" do
      site_id = site_fixture().id
      person = person_fixture(site_id)
      assert {:ok, %Person{} = person} = Persons.update_person(person, @update_attrs)
      assert person.first_name == "some updated first_name"
      assert person.last_name == "some updated last_name"
      assert person.middle_names == "some updated middle_names"
      assert person.note == "some updated note"
      assert person.profile == "some updated profile"
      assert person.suffix == "some updated suffix"
      assert person.prefix == "some updated prefix"
    end

    # test "update_person/2 with invalid data returns error changeset" do
    #   site_id = site_fixture().id
    #   person = person_fixture(site_id)
    #   assert {:error, %Ecto.Changeset{}} = Persons.update_person(person, @invalid_attrs)
    #   assert person == Persons.get_person!(person.id)
    # end

    test "delete_person/1 deletes the person" do
      site_id = site_fixture().id
      person = person_fixture(site_id)
      assert {:ok, %Person{}} = Persons.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      site_id = site_fixture().id
      person = person_fixture(site_id)
      assert %Ecto.Changeset{} = Persons.change_person(person)
    end
  end

  describe "person_tags" do
    alias Crew.Persons.PersonTag

    @valid_attrs %{description: "some description", name: "some name", self_assignable: true}
    @update_attrs %{
      name: "some updated name",
      description: "some updated description",
      self_assignable: false
    }
    @invalid_attrs %{description: nil, name: nil, self_assignable: nil}

    def person_tag_fixture(attrs \\ %{}, site_id) do
      {:ok, person_tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Persons.create_person_tag(site_id)

      person_tag
    end

    test "list_person_tags/0 returns all person_tags" do
      site_id = site_fixture().id
      person_tag = person_tag_fixture(site_id)
      assert Persons.list_person_tags(site_id) == [person_tag]
    end

    test "get_person_tag!/1 returns the person_tag with given id" do
      site_id = site_fixture().id
      person_tag = person_tag_fixture(site_id)
      assert Persons.get_person_tag!(person_tag.id) == person_tag
    end

    test "create_person_tag/1 with valid data creates a person_tag" do
      site_id = site_fixture().id
      assert {:ok, %PersonTag{} = person_tag} = Persons.create_person_tag(@valid_attrs, site_id)
      assert person_tag.name == "some name"
      assert person_tag.description == "some description"
      assert person_tag.self_assignable == true
    end

    test "create_person_tag/1 with invalid data returns error changeset" do
      site_id = site_fixture().id
      assert {:error, %Ecto.Changeset{}} = Persons.create_person_tag(@invalid_attrs, site_id)
    end

    test "update_person_tag/2 with valid data updates the person_tag" do
      site_id = site_fixture().id
      person_tag = person_tag_fixture(site_id)

      assert {:ok, %PersonTag{} = person_tag} =
               Persons.update_person_tag(person_tag, @update_attrs)

      assert person_tag.description == "some updated description"
      assert person_tag.name == "some updated name"
      assert person_tag.self_assignable == false
    end

    test "update_person_tag/2 with invalid data returns error changeset" do
      site_id = site_fixture().id
      person_tag = person_tag_fixture(site_id)
      assert {:error, %Ecto.Changeset{}} = Persons.update_person_tag(person_tag, @invalid_attrs)
      assert person_tag == Persons.get_person_tag!(person_tag.id)
    end

    test "delete_person_tag/1 deletes the person_tag" do
      site_id = site_fixture().id
      person_tag = person_tag_fixture(site_id)
      assert {:ok, %PersonTag{}} = Persons.delete_person_tag(person_tag)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_person_tag!(person_tag.id) end
    end

    test "change_person_tag/1 returns a person_tag changeset" do
      site_id = site_fixture().id
      person_tag = person_tag_fixture(site_id)
      assert %Ecto.Changeset{} = Persons.change_person_tag(person_tag)
    end
  end

  describe "person_rels" do
    alias Crew.Persons.PersonRel

    @valid_attrs %{
      src_label: "Parent",
      src_person_id: 1,
      dest_label: "Child",
      dest_person_id: 2,
      metadata: "some metadata"
    }
    @update_attrs %{metadata: "some updated metadata"}
    @invalid_attrs %{dest_person_id: nil}

    def person_rel_fixture(attrs \\ %{}, site_id) do
      {:ok, person_rel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:src_person_id, person_fixture(site_id).id)
        |> Map.put(:dest_person_id, person_fixture(site_id).id)
        |> Persons.create_person_rel()

      person_rel
    end

    test "list_person_rels/0 returns all person_rels" do
      site_id = site_fixture().id
      person_rel = person_rel_fixture(site_id)
      assert person_rel in Persons.list_person_rels()
    end

    test "get_person_rel!/1 returns the person_rel with given id" do
      site_id = site_fixture().id
      person_rel = person_rel_fixture(site_id)
      assert Persons.get_person_rel!(person_rel.id) == person_rel
    end

    test "create_person_rel/1 with valid data creates a person_rel" do
      site_id = site_fixture().id

      attrs =
        @valid_attrs
        |> Map.put(:src_person_id, person_fixture(site_id).id)
        |> Map.put(:dest_person_id, person_fixture(site_id).id)

      assert {:ok, %PersonRel{} = person_rel} = Persons.create_person_rel(attrs)
      assert person_rel.metadata == "some metadata"
    end

    test "create_person_rel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Persons.create_person_rel(@invalid_attrs)
    end

    test "update_person_rel/2 with valid data updates the person_rel" do
      site_id = site_fixture().id
      person_rel = person_rel_fixture(site_id)

      assert {:ok, %PersonRel{} = person_rel} =
               Persons.update_person_rel(person_rel, @update_attrs)

      assert person_rel.metadata == "some updated metadata"
    end

    test "update_person_rel/2 with invalid data returns error changeset" do
      site_id = site_fixture().id
      person_rel = person_rel_fixture(site_id)
      assert {:error, %Ecto.Changeset{}} = Persons.update_person_rel(person_rel, @invalid_attrs)
      assert person_rel == Persons.get_person_rel!(person_rel.id)
    end

    test "delete_person_rel/1 deletes the person_rel" do
      site_id = site_fixture().id
      person_rel = person_rel_fixture(site_id)
      assert {:ok, %PersonRel{}} = Persons.delete_person_rel(person_rel)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_person_rel!(person_rel.id) end
    end

    test "change_person_rel/1 returns a person_rel changeset" do
      site_id = site_fixture().id
      person_rel = person_rel_fixture(site_id)
      assert %Ecto.Changeset{} = Persons.change_person_rel(person_rel)
    end
  end

  describe "person_notifications" do
    alias Crew.Persons.Notification

    @valid_attrs %{
      subject: "some subject",
      body: "some body",
      notification_type: "some notification_type",
      action_key: "some action_key",
      action_quantity: 42,
      via_email: true,
      via_sms: true,
      via_web: true,
      priority: 42
    }
    @update_attrs %{
      subject: "some updated subject",
      body: "some updated body",
      notification_type: "some updated notification_type",
      action_key: "some updated action_key",
      action_quantity: 43,
      via_email: false,
      via_sms: false,
      via_web: false,
      priority: 43
    }
    @invalid_attrs %{
      subject: nil,
      body: nil,
      notification_type: nil,
      action_key: nil,
      action_quantity: nil,
      via_email: nil,
      via_sms: nil,
      via_web: nil,
      priority: nil
    }

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Persons.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Persons.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Persons.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Persons.create_notification(@valid_attrs)
      assert notification.action_key == "some action_key"
      assert notification.action_quantity == 42
      assert notification.body == "some body"
      assert notification.notification_type == "some notification_type"
      assert notification.priority == 42
      assert notification.subject == "some subject"
      assert notification.via_email == true
      assert notification.via_sms == true
      assert notification.via_web == true
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Persons.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()

      assert {:ok, %Notification{} = notification} =
               Persons.update_notification(notification, @update_attrs)

      assert notification.action_key == "some updated action_key"
      assert notification.action_quantity == 43
      assert notification.body == "some updated body"
      assert notification.notification_type == "some updated notification_type"
      assert notification.priority == 43
      assert notification.subject == "some updated subject"
      assert notification.via_email == false
      assert notification.via_sms == false
      assert notification.via_web == false
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Persons.update_notification(notification, @invalid_attrs)

      assert notification == Persons.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Persons.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Persons.change_notification(notification)
    end
  end
end
