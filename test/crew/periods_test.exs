defmodule Crew.PeriodsTest do
  use Crew.DataCase

  alias Crew.Periods

  describe "periods" do
    alias Crew.Periods.Period

    @valid_attrs %{description: "some description", end_time: "2010-04-17T14:00:00Z", name: "some name", slug: "some slug", start_time: "2010-04-17T14:00:00Z"}
    @update_attrs %{description: "some updated description", end_time: "2011-05-18T15:01:01Z", name: "some updated name", slug: "some updated slug", start_time: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{description: nil, end_time: nil, name: nil, slug: nil, start_time: nil}

    def period_fixture(attrs \\ %{}) do
      {:ok, period} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Periods.create_period()

      period
    end

    test "list_periods/0 returns all periods" do
      period = period_fixture()
      assert Periods.list_periods() == [period]
    end

    test "get_period!/1 returns the period with given id" do
      period = period_fixture()
      assert Periods.get_period!(period.id) == period
    end

    test "create_period/1 with valid data creates a period" do
      assert {:ok, %Period{} = period} = Periods.create_period(@valid_attrs)
      assert period.description == "some description"
      assert period.end_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert period.name == "some name"
      assert period.slug == "some slug"
      assert period.start_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_period/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Periods.create_period(@invalid_attrs)
    end

    test "update_period/2 with valid data updates the period" do
      period = period_fixture()
      assert {:ok, %Period{} = period} = Periods.update_period(period, @update_attrs)
      assert period.description == "some updated description"
      assert period.end_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert period.name == "some updated name"
      assert period.slug == "some updated slug"
      assert period.start_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_period/2 with invalid data returns error changeset" do
      period = period_fixture()
      assert {:error, %Ecto.Changeset{}} = Periods.update_period(period, @invalid_attrs)
      assert period == Periods.get_period!(period.id)
    end

    test "delete_period/1 deletes the period" do
      period = period_fixture()
      assert {:ok, %Period{}} = Periods.delete_period(period)
      assert_raise Ecto.NoResultsError, fn -> Periods.get_period!(period.id) end
    end

    test "change_period/1 returns a period changeset" do
      period = period_fixture()
      assert %Ecto.Changeset{} = Periods.change_period(period)
    end
  end

  describe "period_groups" do
    alias Crew.Periods.PeriodGroup

    @valid_attrs %{description: "some description", event: true, name: "some name", slug: "some slug"}
    @update_attrs %{description: "some updated description", event: false, name: "some updated name", slug: "some updated slug"}
    @invalid_attrs %{description: nil, event: nil, name: nil, slug: nil}

    def period_group_fixture(attrs \\ %{}) do
      {:ok, period_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Periods.create_period_group()

      period_group
    end

    test "list_period_groups/0 returns all period_groups" do
      period_group = period_group_fixture()
      assert Periods.list_period_groups() == [period_group]
    end

    test "get_period_group!/1 returns the period_group with given id" do
      period_group = period_group_fixture()
      assert Periods.get_period_group!(period_group.id) == period_group
    end

    test "create_period_group/1 with valid data creates a period_group" do
      assert {:ok, %PeriodGroup{} = period_group} = Periods.create_period_group(@valid_attrs)
      assert period_group.description == "some description"
      assert period_group.event == true
      assert period_group.name == "some name"
      assert period_group.slug == "some slug"
    end

    test "create_period_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Periods.create_period_group(@invalid_attrs)
    end

    test "update_period_group/2 with valid data updates the period_group" do
      period_group = period_group_fixture()
      assert {:ok, %PeriodGroup{} = period_group} = Periods.update_period_group(period_group, @update_attrs)
      assert period_group.description == "some updated description"
      assert period_group.event == false
      assert period_group.name == "some updated name"
      assert period_group.slug == "some updated slug"
    end

    test "update_period_group/2 with invalid data returns error changeset" do
      period_group = period_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Periods.update_period_group(period_group, @invalid_attrs)
      assert period_group == Periods.get_period_group!(period_group.id)
    end

    test "delete_period_group/1 deletes the period_group" do
      period_group = period_group_fixture()
      assert {:ok, %PeriodGroup{}} = Periods.delete_period_group(period_group)
      assert_raise Ecto.NoResultsError, fn -> Periods.get_period_group!(period_group.id) end
    end

    test "change_period_group/1 returns a period_group changeset" do
      period_group = period_group_fixture()
      assert %Ecto.Changeset{} = Periods.change_period_group(period_group)
    end
  end
end
