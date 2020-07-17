defmodule CrewWeb.ActivityTagLiveTest do
  use CrewWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Crew.Activities

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp fixture(:activity_tag) do
    {:ok, activity_tag} = Activities.create_activity_tag(@create_attrs)
    activity_tag
  end

  defp create_activity_tag(_) do
    activity_tag = fixture(:activity_tag)
    %{activity_tag: activity_tag}
  end

  describe "Index" do
    setup [:create_activity_tag]

    test "lists all activity_tags", %{conn: conn, activity_tag: activity_tag} do
      {:ok, _index_live, html} = live(conn, Routes.activity_tag_index_path(conn, :index))

      assert html =~ "Listing Activity tags"
      assert html =~ activity_tag.description
    end

    test "saves new activity_tag", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.activity_tag_index_path(conn, :index))

      assert index_live |> element("a", "New Activity tag") |> render_click() =~
               "New Activity tag"

      assert_patch(index_live, Routes.activity_tag_index_path(conn, :new))

      assert index_live
             |> form("#activity_tag-form", activity_tag: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#activity_tag-form", activity_tag: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_tag_index_path(conn, :index))

      assert html =~ "Activity tag created successfully"
      assert html =~ "some description"
    end

    test "updates activity_tag in listing", %{conn: conn, activity_tag: activity_tag} do
      {:ok, index_live, _html} = live(conn, Routes.activity_tag_index_path(conn, :index))

      assert index_live |> element("#activity_tag-#{activity_tag.id} a", "Edit") |> render_click() =~
               "Edit Activity tag"

      assert_patch(index_live, Routes.activity_tag_index_path(conn, :edit, activity_tag))

      assert index_live
             |> form("#activity_tag-form", activity_tag: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#activity_tag-form", activity_tag: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_tag_index_path(conn, :index))

      assert html =~ "Activity tag updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes activity_tag in listing", %{conn: conn, activity_tag: activity_tag} do
      {:ok, index_live, _html} = live(conn, Routes.activity_tag_index_path(conn, :index))

      assert index_live |> element("#activity_tag-#{activity_tag.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#activity_tag-#{activity_tag.id}")
    end
  end

  describe "Show" do
    setup [:create_activity_tag]

    test "displays activity_tag", %{conn: conn, activity_tag: activity_tag} do
      {:ok, _show_live, html} = live(conn, Routes.activity_tag_show_path(conn, :show, activity_tag))

      assert html =~ "Show Activity tag"
      assert html =~ activity_tag.description
    end

    test "updates activity_tag within modal", %{conn: conn, activity_tag: activity_tag} do
      {:ok, show_live, _html} = live(conn, Routes.activity_tag_show_path(conn, :show, activity_tag))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Activity tag"

      assert_patch(show_live, Routes.activity_tag_show_path(conn, :edit, activity_tag))

      assert show_live
             |> form("#activity_tag-form", activity_tag: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#activity_tag-form", activity_tag: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_tag_show_path(conn, :show, activity_tag))

      assert html =~ "Activity tag updated successfully"
      assert html =~ "some updated description"
    end
  end
end
