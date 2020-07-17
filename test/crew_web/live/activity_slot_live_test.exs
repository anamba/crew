defmodule CrewWeb.ActivitySlotLiveTest do
  use CrewWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Crew.Activities

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp fixture(:activity_slot) do
    {:ok, activity_slot} = Activities.create_activity_slot(@create_attrs)
    activity_slot
  end

  defp create_activity_slot(_) do
    activity_slot = fixture(:activity_slot)
    %{activity_slot: activity_slot}
  end

  describe "Index" do
    setup [:create_activity_slot]

    test "lists all activity_slots", %{conn: conn, activity_slot: activity_slot} do
      {:ok, _index_live, html} = live(conn, Routes.activity_slot_index_path(conn, :index))

      assert html =~ "Listing Activity slots"
      assert html =~ activity_slot.description
    end

    test "saves new activity_slot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.activity_slot_index_path(conn, :index))

      assert index_live |> element("a", "New Activity slot") |> render_click() =~
               "New Activity slot"

      assert_patch(index_live, Routes.activity_slot_index_path(conn, :new))

      assert index_live
             |> form("#activity_slot-form", activity_slot: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#activity_slot-form", activity_slot: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_slot_index_path(conn, :index))

      assert html =~ "Activity slot created successfully"
      assert html =~ "some description"
    end

    test "updates activity_slot in listing", %{conn: conn, activity_slot: activity_slot} do
      {:ok, index_live, _html} = live(conn, Routes.activity_slot_index_path(conn, :index))

      assert index_live |> element("#activity_slot-#{activity_slot.id} a", "Edit") |> render_click() =~
               "Edit Activity slot"

      assert_patch(index_live, Routes.activity_slot_index_path(conn, :edit, activity_slot))

      assert index_live
             |> form("#activity_slot-form", activity_slot: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#activity_slot-form", activity_slot: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_slot_index_path(conn, :index))

      assert html =~ "Activity slot updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes activity_slot in listing", %{conn: conn, activity_slot: activity_slot} do
      {:ok, index_live, _html} = live(conn, Routes.activity_slot_index_path(conn, :index))

      assert index_live |> element("#activity_slot-#{activity_slot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#activity_slot-#{activity_slot.id}")
    end
  end

  describe "Show" do
    setup [:create_activity_slot]

    test "displays activity_slot", %{conn: conn, activity_slot: activity_slot} do
      {:ok, _show_live, html} = live(conn, Routes.activity_slot_show_path(conn, :show, activity_slot))

      assert html =~ "Show Activity slot"
      assert html =~ activity_slot.description
    end

    test "updates activity_slot within modal", %{conn: conn, activity_slot: activity_slot} do
      {:ok, show_live, _html} = live(conn, Routes.activity_slot_show_path(conn, :show, activity_slot))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Activity slot"

      assert_patch(show_live, Routes.activity_slot_show_path(conn, :edit, activity_slot))

      assert show_live
             |> form("#activity_slot-form", activity_slot: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#activity_slot-form", activity_slot: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_slot_show_path(conn, :show, activity_slot))

      assert html =~ "Activity slot updated successfully"
      assert html =~ "some updated description"
    end
  end
end
