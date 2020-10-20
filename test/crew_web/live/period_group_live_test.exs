# defmodule CrewWeb.PeriodGroupLiveTest do
#   use CrewWeb.ConnCase

#   import Phoenix.LiveViewTest

#   alias Crew.Periods

#   @create_attrs %{description: "some description", event: true, name: "some name", slug: "some slug"}
#   @update_attrs %{description: "some updated description", event: false, name: "some updated name", slug: "some updated slug"}
#   @invalid_attrs %{description: nil, event: nil, name: nil, slug: nil}

#   defp fixture(:period_group) do
#     {:ok, period_group} = Periods.create_period_group(@create_attrs)
#     period_group
#   end

#   defp create_period_group(_) do
#     period_group = fixture(:period_group)
#     %{period_group: period_group}
#   end

#   describe "Index" do
#     setup [:create_period_group]

#     test "lists all period_groups", %{conn: conn, period_group: period_group} do
#       {:ok, _index_live, html} = live(conn, Routes.period_group_index_path(conn, :index))

#       assert html =~ "Listing Period groups"
#       assert html =~ period_group.description
#     end

#     test "saves new period_group", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, Routes.period_group_index_path(conn, :index))

#       assert index_live |> element("a", "New Period group") |> render_click() =~
#                "New Period group"

#       assert_patch(index_live, Routes.period_group_index_path(conn, :new))

#       assert index_live
#              |> form("#period_group-form", period_group: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#period_group-form", period_group: @create_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.period_group_index_path(conn, :index))

#       assert html =~ "Period group created successfully"
#       assert html =~ "some description"
#     end

#     test "updates period_group in listing", %{conn: conn, period_group: period_group} do
#       {:ok, index_live, _html} = live(conn, Routes.period_group_index_path(conn, :index))

#       assert index_live |> element("#period_group-#{period_group.id} a", "Edit") |> render_click() =~
#                "Edit Period group"

#       assert_patch(index_live, Routes.period_group_index_path(conn, :edit, period_group))

#       assert index_live
#              |> form("#period_group-form", period_group: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#period_group-form", period_group: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.period_group_index_path(conn, :index))

#       assert html =~ "Period group updated successfully"
#       assert html =~ "some updated description"
#     end

#     test "deletes period_group in listing", %{conn: conn, period_group: period_group} do
#       {:ok, index_live, _html} = live(conn, Routes.period_group_index_path(conn, :index))

#       assert index_live |> element("#period_group-#{period_group.id} a", "Delete") |> render_click()
#       refute has_element?(index_live, "#period_group-#{period_group.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_period_group]

#     test "displays period_group", %{conn: conn, period_group: period_group} do
#       {:ok, _show_live, html} = live(conn, Routes.period_group_show_path(conn, :show, period_group))

#       assert html =~ "Show Period group"
#       assert html =~ period_group.description
#     end

#     test "updates period_group within modal", %{conn: conn, period_group: period_group} do
#       {:ok, show_live, _html} = live(conn, Routes.period_group_show_path(conn, :show, period_group))

#       assert show_live |> element("a", "Edit") |> render_click() =~
#                "Edit Period group"

#       assert_patch(show_live, Routes.period_group_show_path(conn, :edit, period_group))

#       assert show_live
#              |> form("#period_group-form", period_group: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         show_live
#         |> form("#period_group-form", period_group: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.period_group_show_path(conn, :show, period_group))

#       assert html =~ "Period group updated successfully"
#       assert html =~ "some updated description"
#     end
#   end
# end
