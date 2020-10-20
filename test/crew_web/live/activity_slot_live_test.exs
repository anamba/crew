# defmodule CrewWeb.TimeSlotLiveTest do
#   use CrewWeb.ConnCase

#   import Phoenix.LiveViewTest

#   alias Crew.Activities

#   @create_attrs %{description: "some description", name: "some name"}
#   @update_attrs %{description: "some updated description", name: "some updated name"}
#   @invalid_attrs %{description: nil, name: nil}

#   defp fixture(:time_slot) do
#     {:ok, time_slot} = Activities.create_time_slot(@create_attrs)
#     time_slot
#   end

#   defp create_time_slot(_) do
#     time_slot = fixture(:time_slot)
#     %{time_slot: time_slot}
#   end

#   describe "Index" do
#     setup [:create_time_slot]

#     test "lists all time_slots", %{conn: conn, time_slot: time_slot} do
#       {:ok, _index_live, html} = live(conn, Routes.time_slot_index_path(conn, :index))

#       assert html =~ "Listing Time Slots"
#       assert html =~ time_slot.description
#     end

#     test "saves new time_slot", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, Routes.time_slot_index_path(conn, :index))

#       assert index_live |> element("a", "New Time Slot") |> render_click() =~
#                "New Time Slot"

#       assert_patch(index_live, Routes.time_slot_index_path(conn, :new))

#       assert index_live
#              |> form("#time_slot-form", time_slot: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#time_slot-form", time_slot: @create_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.time_slot_index_path(conn, :index))

#       assert html =~ "Time Slot created successfully"
#       assert html =~ "some description"
#     end

#     test "updates time_slot in listing", %{conn: conn, time_slot: time_slot} do
#       {:ok, index_live, _html} = live(conn, Routes.time_slot_index_path(conn, :index))

#       assert index_live
#              |> element("#time_slot-#{time_slot.id} a", "Edit")
#              |> render_click() =~
#                "Edit Time Slot"

#       assert_patch(index_live, Routes.time_slot_index_path(conn, :edit, time_slot))

#       assert index_live
#              |> form("#time_slot-form", time_slot: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#time_slot-form", time_slot: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.time_slot_index_path(conn, :index))

#       assert html =~ "Time Slot updated successfully"
#       assert html =~ "some updated description"
#     end

#     test "deletes time_slot in listing", %{conn: conn, time_slot: time_slot} do
#       {:ok, index_live, _html} = live(conn, Routes.time_slot_index_path(conn, :index))

#       assert index_live
#              |> element("#time_slot-#{time_slot.id} a", "Delete")
#              |> render_click()

#       refute has_element?(index_live, "#time_slot-#{time_slot.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_time_slot]

#     test "displays time_slot", %{conn: conn, time_slot: time_slot} do
#       {:ok, _show_live, html} = live(conn, Routes.time_slot_show_path(conn, :show, time_slot))

#       assert html =~ "Show Time Slot"
#       assert html =~ time_slot.description
#     end

#     test "updates time_slot within modal", %{conn: conn, time_slot: time_slot} do
#       {:ok, show_live, _html} = live(conn, Routes.time_slot_show_path(conn, :show, time_slot))

#       assert show_live |> element("a", "Edit") |> render_click() =~
#                "Edit Time Slot"

#       assert_patch(show_live, Routes.time_slot_show_path(conn, :edit, time_slot))

#       assert show_live
#              |> form("#time_slot-form", time_slot: @invalid_attrs)
#              |> render_change() =~ "can&apos;t be blank"

#       {:ok, _, html} =
#         show_live
#         |> form("#time_slot-form", time_slot: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.time_slot_show_path(conn, :show, time_slot))

#       assert html =~ "Time Slot updated successfully"
#       assert html =~ "some updated description"
#     end
#   end
# end
