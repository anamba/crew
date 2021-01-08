defmodule CrewWeb.UserLive.Index do
  use CrewWeb, :live_view

  alias Crew.Accounts
  alias Crew.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket = assign_from_session(socket, session)

    socket =
      socket
      |> assign_new(:users, fn -> list_users(socket) end)

    # |> assign_new(:inactive_users, fn -> list_inactive_users() end))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user = Accounts.get_user!(id)

    socket
    |> assign(:page_title, "Editing: #{user.name}")
    |> assign(:user, user)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, assign(socket, :users, list_users(socket))}
  end

  defp list_users(socket) do
    Accounts.list_users(socket.assigns.site_id)
  end
end
