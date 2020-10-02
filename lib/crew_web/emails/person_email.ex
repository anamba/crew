defmodule CrewWeb.PersonEmail do
  use Phoenix.Swoosh, view: CrewWeb.PersonEmailView, layout: {CrewWeb.LayoutView, :email}

  def confirm_email(person, site) do
    new()
    |> to({person.name, person.email})
    |> from({site.name, site.email})
    |> subject("Please confirm your email address")
    |> render_body(:confirm_email)
  end

  def confirm_signup(person, site) do
    new()
    |> to({person.name, person.email})
    |> from({site.name, site.email})
    |> subject("Thank you for signing up")
    |> render_body(:confirm_signup)
  end
end
