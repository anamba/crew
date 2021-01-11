defmodule CrewWeb.PersonEmail do
  use Bamboo.Phoenix, view: CrewWeb.PersonEmailView

  alias Crew.Persons.Person

  def base_email(site) do
    new_email()
    # |> from({site.name, site.sender_email})
    |> from({site.name, "no-reply@crew-app.org"})
    |> put_layout({CrewWeb.LayoutView, :email})
  end

  def confirm_email(%Person{} = person) do
    site = person.site

    base_email(site)
    |> to(person.new_email || person.email)
    |> subject("Please confirm your email address")
    |> render(:confirm_email, person: person, site: site, code: Person.generate_totp_code(person))
  end

  def confirm_signup(%Person{} = person) do
    site = person.site

    base_email(site)
    |> to({person.name, person.email})
    |> subject("Thank you for signing up")
    |> render(:confirm_signup, person: person, site: site)
  end

  def notification(%Person{} = person, notifications) do
    site = Crew.Repo.preload(person, [:site]).site

    base_email(site)
    |> to(person.email)
    |> subject("[Crew Scheduler] Confirm your email address change")
    |> render(:notification, person: person, site: site, notifications: notifications)
  end
end
