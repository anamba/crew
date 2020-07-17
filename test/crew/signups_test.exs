defmodule Crew.SignupsTest do
  use Crew.DataCase

  alias Crew.Signups

  describe "signups" do
    alias Crew.Signups.Signup

    @valid_attrs %{end_time: "2010-04-17T14:00:00Z", last_reminded_at: "2010-04-17T14:00:00Z", start_time: "2010-04-17T14:00:00Z"}
    @update_attrs %{end_time: "2011-05-18T15:01:01Z", last_reminded_at: "2011-05-18T15:01:01Z", start_time: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{end_time: nil, last_reminded_at: nil, start_time: nil}

    def signup_fixture(attrs \\ %{}) do
      {:ok, signup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Signups.create_signup()

      signup
    end

    test "list_signups/0 returns all signups" do
      signup = signup_fixture()
      assert Signups.list_signups() == [signup]
    end

    test "get_signup!/1 returns the signup with given id" do
      signup = signup_fixture()
      assert Signups.get_signup!(signup.id) == signup
    end

    test "create_signup/1 with valid data creates a signup" do
      assert {:ok, %Signup{} = signup} = Signups.create_signup(@valid_attrs)
      assert signup.end_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert signup.last_reminded_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert signup.start_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_signup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Signups.create_signup(@invalid_attrs)
    end

    test "update_signup/2 with valid data updates the signup" do
      signup = signup_fixture()
      assert {:ok, %Signup{} = signup} = Signups.update_signup(signup, @update_attrs)
      assert signup.end_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert signup.last_reminded_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert signup.start_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_signup/2 with invalid data returns error changeset" do
      signup = signup_fixture()
      assert {:error, %Ecto.Changeset{}} = Signups.update_signup(signup, @invalid_attrs)
      assert signup == Signups.get_signup!(signup.id)
    end

    test "delete_signup/1 deletes the signup" do
      signup = signup_fixture()
      assert {:ok, %Signup{}} = Signups.delete_signup(signup)
      assert_raise Ecto.NoResultsError, fn -> Signups.get_signup!(signup.id) end
    end

    test "change_signup/1 returns a signup changeset" do
      signup = signup_fixture()
      assert %Ecto.Changeset{} = Signups.change_signup(signup)
    end
  end
end
