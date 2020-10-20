# defmodule CrewWeb.ActivityTagGroupLiveTest do
#   use CrewWeb.ConnCase

#   import Phoenix.LiveViewTest

#   alias Crew.Activities

#   @create_attrs %{description: "some description", name: "some name"}
#   @update_attrs %{description: "some updated description", name: "some updated name"}
#   @invalid_attrs %{description: nil, name: nil}

#   defp fixture(:activity_tag_group) do
#     {:ok, activity_tag_group} = Activities.create_activity_tag_group(@create_attrs)
#     activity_tag_group
#   end

#   defp create_activity_tag_group(_) do
#     activity_tag_group = fixture(:activity_tag_group)
#     %{activity_tag_group: activity_tag_group}
#   end

#   describe "Index" do
#     setup [:create_activity_tag_group]

#     test "lists all activity_tag_groups", %{conn: conn, activity_tag_group: activity_tag_group} do
#       {:ok, _index_live, html} = live(conn, Routes.activity_tag_group_index_path(conn, :index))

#       assert html =~ "Listing Activity tag groups"
#       assert html =~ activity_tag_group.description
#     end

#     test "saves new activity_tag_group", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, Routes.activity_tag_group_index_path(conn, :index))

#       assert index_live |> element("a", "New Activity tag group") |> render_click() =~
#                "New Activity tag group"

#       assert_patch(index_live, Routes.activity_tag_group_index_path(conn, :new))

#       assert index_live
#              |> form("#activity_tag_group-form", activity_tag_group: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#activity_tag_group-form", activity_tag_group: @create_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.activity_tag_group_index_path(conn, :index))

#       assert html =~ "Activity tag group created successfully"
#       assert html =~ "some description"
#     end

#     test "updates activity_tag_group in listing", %{conn: conn, activity_tag_group: activity_tag_group} do
#       {:ok, index_live, _html} = live(conn, Routes.activity_tag_group_index_path(conn, :index))

#       assert index_live |> element("#activity_tag_group-#{activity_tag_group.id} a", "Edit") |> render_click() =~
#                "Edit Activity tag group"

#       assert_patch(index_live, Routes.activity_tag_group_index_path(conn, :edit, activity_tag_group))

#       assert index_live
#              |> form("#activity_tag_group-form", activity_tag_group: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#activity_tag_group-form", activity_tag_group: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.activity_tag_group_index_path(conn, :index))

#       assert html =~ "Activity tag group updated successfully"
#       assert html =~ "some updated description"
#     end

#     test "deletes activity_tag_group in listing", %{conn: conn, activity_tag_group: activity_tag_group} do
#       {:ok, index_live, _html} = live(conn, Routes.activity_tag_group_index_path(conn, :index))

#       assert index_live |> element("#activity_tag_group-#{activity_tag_group.id} a", "Delete") |> render_click()
#       refute has_element?(index_live, "#activity_tag_group-#{activity_tag_group.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_activity_tag_group]

#     test "displays activity_tag_group", %{conn: conn, activity_tag_group: activity_tag_group} do
#       {:ok, _show_live, html} = live(conn, Routes.activity_tag_group_show_path(conn, :show, activity_tag_group))

#       assert html =~ "Show Activity tag group"
#       assert html =~ activity_tag_group.description
#     end

#     test "updates activity_tag_group within modal", %{conn: conn, activity_tag_group: activity_tag_group} do
#       {:ok, show_live, _html} = live(conn, Routes.activity_tag_group_show_path(conn, :show, activity_tag_group))

#       assert show_live |> element("a", "Edit") |> render_click() =~
#                "Edit Activity tag group"

#       assert_patch(show_live, Routes.activity_tag_group_show_path(conn, :edit, activity_tag_group))

#       assert show_live
#              |> form("#activity_tag_group-form", activity_tag_group: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         show_live
#         |> form("#activity_tag_group-form", activity_tag_group: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.activity_tag_group_show_path(conn, :show, activity_tag_group))

#       assert html =~ "Activity tag group updated successfully"
#       assert html =~ "some updated description"
#     end
#   end
# end
