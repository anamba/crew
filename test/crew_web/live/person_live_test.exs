defmodule CrewWeb.PersonLiveTest do
  use CrewWeb.ConnCase

  import Phoenix.LiveViewTest
  import Crew.AccountsFixtures

  alias Crew.Persons
  alias Crew.Sites

  @create_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    middle_names: "some middle_names",
    note: "some note",
    profile: "some profile",
    suffix: "some suffix"
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    middle_names: "some updated middle_names",
    note: "some updated note",
    profile: "some updated profile",
    suffix: "some updated suffix"
  }
  @invalid_attrs %{
    first_name: nil,
    last_name: nil,
    middle_names: nil,
    note: nil,
    profile: nil,
    suffix: nil
  }

  defp fixture(:site) do
    {:ok, site} =
      Sites.upsert_site(%{name: "Test", primary_domain: "crew.example.com"}, %{slug: "test"})

    site
  end

  defp fixture(:person, site_id) do
    {:ok, person} = Persons.create_person(@create_attrs, site_id)
    person
  end

  defp create_site(_) do
    %{site: fixture(:site)}
  end

  defp create_person(%{site: site}) do
    person = fixture(:person, site.id)
    %{person: person}
  end

  defp create_user_and_log_in(%{site: site, conn: conn}) do
    user = user_fixture(site_id: site.id)
    %{user: user, conn: conn |> log_in_user(user) |> assign(:current_user, user)}
  end

  describe "Index" do
    setup [:create_site, :create_person, :create_user_and_log_in]

    test "lists all persons", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, Routes.person_index_path(conn, :index))

      # assert html =~ "Listing Persons"
      assert html =~ person.first_name
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.person_index_path(conn, :index))

      assert index_live |> element("a", "New") |> render_click() =~ "New"

      assert_patch(index_live, Routes.person_index_path(conn, :new))

      # assert index_live
      #        |> form("#person-form", person: @invalid_attrs)
      #        |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#person-form", person: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.person_index_path(conn, :index))

      assert html =~ "created successfully"
      assert html =~ "some first_name"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, Routes.person_index_path(conn, :index))

      assert index_live |> element("#person-#{person.id} a", "Edit") |> render_click() =~ "Edit"

      assert_patch(index_live, Routes.person_index_path(conn, :edit, person))

      # assert index_live
      #        |> form("#person-form", person: @invalid_attrs)
      #        |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#person-form", person: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.person_index_path(conn, :index))

      assert html =~ "updated successfully"
      assert html =~ "some updated first_name"
    end

    # test "deletes person in listing", %{conn: conn, person: person} do
    #   {:ok, index_live, _html} = live(conn, Routes.person_index_path(conn, :index))

    #   assert index_live |> element("#person-#{person.id} a", "Delete") |> render_click()
    #   refute has_element?(index_live, "#person-#{person.id}")
    # end
  end

  describe "Show" do
    setup [:create_site, :create_person, :create_user_and_log_in]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, Routes.person_show_path(conn, :show, person))

      # assert html =~ "Show Person"
      assert html =~ person.first_name
    end

    test "updates person within modal", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, Routes.person_show_path(conn, :show, person))

      assert show_live |> element("a", "Edit") |> render_click() =~ "Edit"

      assert_patch(show_live, Routes.person_show_path(conn, :edit, person))

      # assert show_live
      #        |> form("#person-form", person: @invalid_attrs)
      #        |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#person-form", person: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.person_show_path(conn, :show, person))

      assert html =~ "updated successfully"
      assert html =~ "some updated first_name"
    end
  end
end
