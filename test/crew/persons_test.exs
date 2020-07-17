defmodule Crew.PersonsTest do
  use Crew.DataCase

  alias Crew.Persons

  describe "persons" do
    alias Crew.Persons.Person

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name", middle_names: "some middle_names", note: "some note", profile: "some profile", suffix: "some suffix", title: "some title"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", middle_names: "some updated middle_names", note: "some updated note", profile: "some updated profile", suffix: "some updated suffix", title: "some updated title"}
    @invalid_attrs %{first_name: nil, last_name: nil, middle_names: nil, note: nil, profile: nil, suffix: nil, title: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Persons.create_person()

      person
    end

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Persons.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Persons.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = Persons.create_person(@valid_attrs)
      assert person.first_name == "some first_name"
      assert person.last_name == "some last_name"
      assert person.middle_names == "some middle_names"
      assert person.note == "some note"
      assert person.profile == "some profile"
      assert person.suffix == "some suffix"
      assert person.title == "some title"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Persons.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, %Person{} = person} = Persons.update_person(person, @update_attrs)
      assert person.first_name == "some updated first_name"
      assert person.last_name == "some updated last_name"
      assert person.middle_names == "some updated middle_names"
      assert person.note == "some updated note"
      assert person.profile == "some updated profile"
      assert person.suffix == "some updated suffix"
      assert person.title == "some updated title"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Persons.update_person(person, @invalid_attrs)
      assert person == Persons.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Persons.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Persons.change_person(person)
    end
  end
end
