defmodule CrewWeb.PeriodGroupLive.FormComponent do
  use CrewWeb, :live_component

  alias Crew.Periods

  @impl true
  def update(%{period_group: period_group} = assigns, socket) do
    changeset = Periods.change_period_group(period_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"period_group" => period_group_params}, socket) do
    changeset =
      socket.assigns.period_group
      |> Periods.change_period_group(period_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"period_group" => period_group_params}, socket) do
    save_period_group(socket, socket.assigns.action, period_group_params)
  end

  defp save_period_group(socket, :edit, period_group_params) do
    case Periods.update_period_group(socket.assigns.period_group, period_group_params) do
      {:ok, _period_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Period group updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_period_group(socket, :new, period_group_params) do
    case Periods.create_period_group(period_group_params) do
      {:ok, _period_group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Period group created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
