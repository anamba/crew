defmodule CrewWeb.SignupLiveTest do
  use CrewWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Crew.Signups

  @create_attrs %{end_time: "2010-04-17T14:00:00Z", last_reminded_at: "2010-04-17T14:00:00Z", start_time: "2010-04-17T14:00:00Z"}
  @update_attrs %{end_time: "2011-05-18T15:01:01Z", last_reminded_at: "2011-05-18T15:01:01Z", start_time: "2011-05-18T15:01:01Z"}
  @invalid_attrs %{end_time: nil, last_reminded_at: nil, start_time: nil}

  defp fixture(:signup) do
    {:ok, signup} = Signups.create_signup(@create_attrs)
    signup
  end

  defp create_signup(_) do
    signup = fixture(:signup)
    %{signup: signup}
  end

  describe "Index" do
    setup [:create_signup]

    test "lists all signups", %{conn: conn, signup: signup} do
      {:ok, _index_live, html} = live(conn, Routes.signup_index_path(conn, :index))

      assert html =~ "Listing Signups"
    end

    test "saves new signup", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.signup_index_path(conn, :index))

      assert index_live |> element("a", "New Signup") |> render_click() =~
               "New Signup"

      assert_patch(index_live, Routes.signup_index_path(conn, :new))

      assert index_live
             |> form("#signup-form", signup: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#signup-form", signup: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.signup_index_path(conn, :index))

      assert html =~ "Signup created successfully"
    end

    test "updates signup in listing", %{conn: conn, signup: signup} do
      {:ok, index_live, _html} = live(conn, Routes.signup_index_path(conn, :index))

      assert index_live |> element("#signup-#{signup.id} a", "Edit") |> render_click() =~
               "Edit Signup"

      assert_patch(index_live, Routes.signup_index_path(conn, :edit, signup))

      assert index_live
             |> form("#signup-form", signup: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#signup-form", signup: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.signup_index_path(conn, :index))

      assert html =~ "Signup updated successfully"
    end

    test "deletes signup in listing", %{conn: conn, signup: signup} do
      {:ok, index_live, _html} = live(conn, Routes.signup_index_path(conn, :index))

      assert index_live |> element("#signup-#{signup.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#signup-#{signup.id}")
    end
  end

  describe "Show" do
    setup [:create_signup]

    test "displays signup", %{conn: conn, signup: signup} do
      {:ok, _show_live, html} = live(conn, Routes.signup_show_path(conn, :show, signup))

      assert html =~ "Show Signup"
    end

    test "updates signup within modal", %{conn: conn, signup: signup} do
      {:ok, show_live, _html} = live(conn, Routes.signup_show_path(conn, :show, signup))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Signup"

      assert_patch(show_live, Routes.signup_show_path(conn, :edit, signup))

      assert show_live
             |> form("#signup-form", signup: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#signup-form", signup: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.signup_show_path(conn, :show, signup))

      assert html =~ "Signup updated successfully"
    end
  end
end
