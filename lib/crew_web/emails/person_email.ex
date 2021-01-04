defmodule CrewWeb.PersonEmail do
  use Bamboo.Phoenix, view: CrewWeb.PersonEmailView

  alias Crew.Persons.Person

  def base_email do
    new_email()
    |> put_layout({CrewWeb.LayoutView, :email})
  end

  def confirm_email(%Person{} = person) do
    site = person.site

    base_email()
    # |> from({site.name, site.sender_email})
    |> from({site.name, "no-reply@biggerbird.com"})
    |> to(person.new_email || person.email)
    |> subject("Please confirm your email address")
    |> render(:confirm_email, person: person, site: site, code: Person.generate_totp_code(person))
  end

  def confirm_signup(%Person{} = person) do
    site = person.site

    base_email()
    |> to({person.name, person.email})
    # |> from({site.name, site.sender_email})
    |> from({site.name, "no-reply@biggerbird.com"})
    |> subject("Thank you for signing up")
    |> render(:confirm_signup, person: person, site: site)
  end
end
