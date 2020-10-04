defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Show do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_from_session(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:<%= schema.singular %>, <%= inspect context.alias %>.get_<%= schema.singular %>!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(id)
    {:ok, _} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= schema.singular %>)

    {:noreply, assign(socket, :<%= schema.collection %>, list_<%=schema.plural %>(socket.assigns.site_id))}
  end

  defp page_title(:show, <%= schema.singular %>), do: "Show <%= schema.human_singular %>"
  defp page_title(:edit, <%= schema.singular %>), do: "Edit <%= schema.human_singular %>"
end
