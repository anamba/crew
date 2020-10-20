# defmodule CrewWeb.PeriodLiveTest do
#   use CrewWeb.ConnCase

#   import Phoenix.LiveViewTest

#   alias Crew.Periods

#   @create_attrs %{description: "some description", end_time: "2010-04-17T14:00:00Z", name: "some name", slug: "some slug", start_time: "2010-04-17T14:00:00Z"}
#   @update_attrs %{description: "some updated description", end_time: "2011-05-18T15:01:01Z", name: "some updated name", slug: "some updated slug", start_time: "2011-05-18T15:01:01Z"}
#   @invalid_attrs %{description: nil, end_time: nil, name: nil, slug: nil, start_time: nil}

#   defp fixture(:period) do
#     {:ok, period} = Periods.create_period(@create_attrs)
#     period
#   end

#   defp create_period(_) do
#     period = fixture(:period)
#     %{period: period}
#   end

#   describe "Index" do
#     setup [:create_period]

#     test "lists all periods", %{conn: conn, period: period} do
#       {:ok, _index_live, html} = live(conn, Routes.period_index_path(conn, :index))

#       assert html =~ "Listing Periods"
#       assert html =~ period.description
#     end

#     test "saves new period", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, Routes.period_index_path(conn, :index))

#       assert index_live |> element("a", "New Period") |> render_click() =~
#                "New Period"

#       assert_patch(index_live, Routes.period_index_path(conn, :new))

#       assert index_live
#              |> form("#period-form", period: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#period-form", period: @create_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.period_index_path(conn, :index))

#       assert html =~ "Period created successfully"
#       assert html =~ "some description"
#     end

#     test "updates period in listing", %{conn: conn, period: period} do
#       {:ok, index_live, _html} = live(conn, Routes.period_index_path(conn, :index))

#       assert index_live |> element("#period-#{period.id} a", "Edit") |> render_click() =~
#                "Edit Period"

#       assert_patch(index_live, Routes.period_index_path(conn, :edit, period))

#       assert index_live
#              |> form("#period-form", period: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#period-form", period: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.period_index_path(conn, :index))

#       assert html =~ "Period updated successfully"
#       assert html =~ "some updated description"
#     end

#     test "deletes period in listing", %{conn: conn, period: period} do
#       {:ok, index_live, _html} = live(conn, Routes.period_index_path(conn, :index))

#       assert index_live |> element("#period-#{period.id} a", "Delete") |> render_click()
#       refute has_element?(index_live, "#period-#{period.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_period]

#     test "displays period", %{conn: conn, period: period} do
#       {:ok, _show_live, html} = live(conn, Routes.period_show_path(conn, :show, period))

#       assert html =~ "Show Period"
#       assert html =~ period.description
#     end

#     test "updates period within modal", %{conn: conn, period: period} do
#       {:ok, show_live, _html} = live(conn, Routes.period_show_path(conn, :show, period))

#       assert show_live |> element("a", "Edit") |> render_click() =~
#                "Edit Period"

#       assert_patch(show_live, Routes.period_show_path(conn, :edit, period))

#       assert show_live
#              |> form("#period-form", period: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         show_live
#         |> form("#period-form", period: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.period_show_path(conn, :show, period))

#       assert html =~ "Period updated successfully"
#       assert html =~ "some updated description"
#     end
#   end
# end
