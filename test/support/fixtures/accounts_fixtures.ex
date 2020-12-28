defmodule Crew.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crew.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "o8NjdqKjrmfiU3E-bsPWJVvm"

  # def user_fixture(attrs \\ %{}) do
  #   {:ok, user} =
  #     attrs
  #     |> Enum.into(@valid_attrs)
  #     |> Accounts.create_user()

  #   user
  # end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Crew.Accounts.register_user()

    if attrs[:site_id] do
      {:ok, _site_member} =
        Crew.Sites.upsert_site_member(%{role: "owner"}, %{user_id: user.id}, attrs[:site_id])
    end

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
