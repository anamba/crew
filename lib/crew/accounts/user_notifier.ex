defmodule Crew.Accounts.UserNotifier do
  use Bamboo.Phoenix, view: CrewWeb.UserNotifierView

  alias Crew.Mailer

  defp base_email do
    new_email()
    |> from("no-reply@biggerbird.com")
    # |> put_header("Reply-To", "someone@example.com")
    |> put_layout({CrewWeb.LayoutView, :user_email})
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    email =
      base_email()
      |> to(user.email)
      |> subject("Welcome to Crew Scheduler")
      |> render(:confirmation_instructions, user: user, url: url)
      |> Mailer.deliver_later()

    {:ok, email}
  end

  @doc """
  Deliver instructions to reset password account.
  """
  def deliver_reset_password_instructions(user, url) do
    email =
      base_email()
      |> to(user.email)
      |> subject("[Crew Scheduler] Password reset instructions")
      |> render(:reset_password_instructions, user: user, url: url)
      |> Mailer.deliver_later()

    {:ok, email}
  end

  @doc """
  Deliver instructions to update your email.
  """
  def deliver_update_email_instructions(user, url) do
    email =
      base_email()
      |> to(user.email)
      |> subject("[Crew Scheduler] Confirm your email address change")
      |> render(:update_email_instructions, user: user, url: url)
      |> Mailer.deliver_later()

    {:ok, email}
  end
end
