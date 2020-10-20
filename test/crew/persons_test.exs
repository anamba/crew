defmodule Crew.PersonsTest do
  use ExUnit.Case

  doctest Crew.Persons.Person

  # use Crew.DataCase

  # alias Crew.Persons

  # describe "persons" do
  #   alias Crew.Persons.Person

  #   @valid_attrs %{
  #     first_name: "some first_name",
  #     last_name: "some last_name",
  #     middle_names: "some middle_names",
  #     note: "some note",
  #     profile: "some profile",
  #     suffix: "some suffix",
  #     title: "some title"
  #   }
  #   @update_attrs %{
  #     first_name: "some updated first_name",
  #     last_name: "some updated last_name",
  #     middle_names: "some updated middle_names",
  #     note: "some updated note",
  #     profile: "some updated profile",
  #     suffix: "some updated suffix",
  #     title: "some updated title"
  #   }
  #   @invalid_attrs %{
  #     first_name: nil,
  #     last_name: nil,
  #     middle_names: nil,
  #     note: nil,
  #     profile: nil,
  #     suffix: nil,
  #     title: nil
  #   }

  #   def person_fixture(attrs \\ %{}) do
  #     {:ok, person} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Persons.create_person()

  #     person
  #   end

  #   test "list_persons/0 returns all persons" do
  #     person = person_fixture()
  #     assert Persons.list_persons() == [person]
  #   end

  #   test "get_person!/1 returns the person with given id" do
  #     person = person_fixture()
  #     assert Persons.get_person!(person.id) == person
  #   end

  #   test "create_person/1 with valid data creates a person" do
  #     assert {:ok, %Person{} = person} = Persons.create_person(@valid_attrs)
  #     assert person.first_name == "some first_name"
  #     assert person.last_name == "some last_name"
  #     assert person.middle_names == "some middle_names"
  #     assert person.note == "some note"
  #     assert person.profile == "some profile"
  #     assert person.suffix == "some suffix"
  #     assert person.title == "some title"
  #   end

  #   test "create_person/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Persons.create_person(@invalid_attrs)
  #   end

  #   test "update_person/2 with valid data updates the person" do
  #     person = person_fixture()
  #     assert {:ok, %Person{} = person} = Persons.update_person(person, @update_attrs)
  #     assert person.first_name == "some updated first_name"
  #     assert person.last_name == "some updated last_name"
  #     assert person.middle_names == "some updated middle_names"
  #     assert person.note == "some updated note"
  #     assert person.profile == "some updated profile"
  #     assert person.suffix == "some updated suffix"
  #     assert person.title == "some updated title"
  #   end

  #   test "update_person/2 with invalid data returns error changeset" do
  #     person = person_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Persons.update_person(person, @invalid_attrs)
  #     assert person == Persons.get_person!(person.id)
  #   end

  #   test "delete_person/1 deletes the person" do
  #     person = person_fixture()
  #     assert {:ok, %Person{}} = Persons.delete_person(person)
  #     assert_raise Ecto.NoResultsError, fn -> Persons.get_person!(person.id) end
  #   end

  #   test "change_person/1 returns a person changeset" do
  #     person = person_fixture()
  #     assert %Ecto.Changeset{} = Persons.change_person(person)
  #   end
  # end

  # describe "person_tags" do
  #   alias Crew.Persons.PersonTag

  #   @valid_attrs %{description: "some description", name: "some name", self_assignable: true}
  #   @update_attrs %{
  #     description: "some updated description",
  #     name: "some updated name",
  #     self_assignable: false
  #   }
  #   @invalid_attrs %{description: nil, name: nil, self_assignable: nil}

  #   def person_tag_fixture(attrs \\ %{}) do
  #     {:ok, person_tag} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Persons.create_person_tag()

  #     person_tag
  #   end

  #   test "list_person_tags/0 returns all person_tags" do
  #     person_tag = person_tag_fixture()
  #     assert Persons.list_person_tags() == [person_tag]
  #   end

  #   test "get_person_tag!/1 returns the person_tag with given id" do
  #     person_tag = person_tag_fixture()
  #     assert Persons.get_person_tag!(person_tag.id) == person_tag
  #   end

  #   test "create_person_tag/1 with valid data creates a person_tag" do
  #     assert {:ok, %PersonTag{} = person_tag} = Persons.create_person_tag(@valid_attrs)
  #     assert person_tag.description == "some description"
  #     assert person_tag.name == "some name"
  #     assert person_tag.self_assignable == true
  #   end

  #   test "create_person_tag/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Persons.create_person_tag(@invalid_attrs)
  #   end

  #   test "update_person_tag/2 with valid data updates the person_tag" do
  #     person_tag = person_tag_fixture()

  #     assert {:ok, %PersonTag{} = person_tag} =
  #              Persons.update_person_tag(person_tag, @update_attrs)

  #     assert person_tag.description == "some updated description"
  #     assert person_tag.name == "some updated name"
  #     assert person_tag.self_assignable == false
  #   end

  #   test "update_person_tag/2 with invalid data returns error changeset" do
  #     person_tag = person_tag_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Persons.update_person_tag(person_tag, @invalid_attrs)
  #     assert person_tag == Persons.get_person_tag!(person_tag.id)
  #   end

  #   test "delete_person_tag/1 deletes the person_tag" do
  #     person_tag = person_tag_fixture()
  #     assert {:ok, %PersonTag{}} = Persons.delete_person_tag(person_tag)
  #     assert_raise Ecto.NoResultsError, fn -> Persons.get_person_tag!(person_tag.id) end
  #   end

  #   test "change_person_tag/1 returns a person_tag changeset" do
  #     person_tag = person_tag_fixture()
  #     assert %Ecto.Changeset{} = Persons.change_person_tag(person_tag)
  #   end
  # end

  # describe "person_rels" do
  #   alias Crew.Persons.PersonRel

  #   @valid_attrs %{metadata: "some metadata", verb: "some verb"}
  #   @update_attrs %{metadata: "some updated metadata", verb: "some updated verb"}
  #   @invalid_attrs %{metadata: nil, verb: nil}

  #   def person_rel_fixture(attrs \\ %{}) do
  #     {:ok, person_rel} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Persons.create_person_rel()

  #     person_rel
  #   end

  #   test "list_person_rels/0 returns all person_rels" do
  #     person_rel = person_rel_fixture()
  #     assert Persons.list_person_rels() == [person_rel]
  #   end

  #   test "get_person_rel!/1 returns the person_rel with given id" do
  #     person_rel = person_rel_fixture()
  #     assert Persons.get_person_rel!(person_rel.id) == person_rel
  #   end

  #   test "create_person_rel/1 with valid data creates a person_rel" do
  #     assert {:ok, %PersonRel{} = person_rel} = Persons.create_person_rel(@valid_attrs)
  #     assert person_rel.metadata == "some metadata"
  #     assert person_rel.verb == "some verb"
  #   end

  #   test "create_person_rel/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Persons.create_person_rel(@invalid_attrs)
  #   end

  #   test "update_person_rel/2 with valid data updates the person_rel" do
  #     person_rel = person_rel_fixture()

  #     assert {:ok, %PersonRel{} = person_rel} =
  #              Persons.update_person_rel(person_rel, @update_attrs)

  #     assert person_rel.metadata == "some updated metadata"
  #     assert person_rel.verb == "some updated verb"
  #   end

  #   test "update_person_rel/2 with invalid data returns error changeset" do
  #     person_rel = person_rel_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Persons.update_person_rel(person_rel, @invalid_attrs)
  #     assert person_rel == Persons.get_person_rel!(person_rel.id)
  #   end

  #   test "delete_person_rel/1 deletes the person_rel" do
  #     person_rel = person_rel_fixture()
  #     assert {:ok, %PersonRel{}} = Persons.delete_person_rel(person_rel)
  #     assert_raise Ecto.NoResultsError, fn -> Persons.get_person_rel!(person_rel.id) end
  #   end

  #   test "change_person_rel/1 returns a person_rel changeset" do
  #     person_rel = person_rel_fixture()
  #     assert %Ecto.Changeset{} = Persons.change_person_rel(person_rel)
  #   end
  # end
end
