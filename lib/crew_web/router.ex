defmodule CrewWeb.Router do
  use CrewWeb, :router

  import CrewWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CrewWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug CrewWeb.Plugs.SetSite
    plug CrewWeb.Plugs.SetPerson
  end

  pipeline :public do
    plug :put_root_layout, {CrewWeb.LayoutView, :public}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrewWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrewWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CrewWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", CrewWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/auth/register", UserRegistrationController, :new
    post "/auth/register", UserRegistrationController, :create
    get "/auth/log_in", UserSessionController, :new
    post "/auth/log_in", UserSessionController, :create
    get "/auth/reset_password", UserResetPasswordController, :new
    post "/auth/reset_password", UserResetPasswordController, :create
    get "/auth/reset_password/:token", UserResetPasswordController, :edit
    put "/auth/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", CrewWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/account/settings", UserSettingsController, :edit
    put "/account/settings/update_password", UserSettingsController, :update_password
    put "/account/settings/update_email", UserSettingsController, :update_email
    get "/account/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/admin", CrewWeb do
    # disable auth for now
    # pipe_through [:browser, :require_authenticated_user]
    pipe_through [:browser]

    live "/activities", ActivityLive.Index, :index
    live "/activities/new", ActivityLive.Index, :new
    live "/activities/:id/edit", ActivityLive.Index, :edit
    live "/activities/:id", ActivityLive.Show, :show
    live "/activities/:id/show/edit", ActivityLive.Show, :edit

    live "/activity_tags", ActivityTagLive.Index, :index
    live "/activity_tags/new", ActivityTagLive.Index, :new
    live "/activity_tags/:id/edit", ActivityTagLive.Index, :edit
    live "/activity_tags/:id", ActivityTagLive.Show, :show
    live "/activity_tags/:id/show/edit", ActivityTagLive.Show, :edit

    live "/activity_tag_groups", ActivityTagGroupLive.Index, :index
    live "/activity_tag_groups/new", ActivityTagGroupLive.Index, :new
    live "/activity_tag_groups/:id/edit", ActivityTagGroupLive.Index, :edit
    live "/activity_tag_groups/:id", ActivityTagGroupLive.Show, :show
    live "/activity_tag_groups/:id/show/edit", ActivityTagGroupLive.Show, :edit

    live "/locations", LocationLive.Index, :index
    live "/locations/new", LocationLive.Index, :new
    live "/locations/:id/edit", LocationLive.Index, :edit
    live "/locations/:id", LocationLive.Show, :show
    live "/locations/:id/show/edit", LocationLive.Show, :edit

    live "/persons", PersonLive.Index, :index
    live "/persons/new", PersonLive.Index, :new
    live "/persons/:id/edit", PersonLive.Index, :edit
    live "/persons/:id", PersonLive.Show, :show
    live "/persons/:id/show/edit", PersonLive.Show, :edit

    live "/periods", PeriodLive.Index, :index
    live "/periods/new", PeriodLive.Index, :new
    live "/periods/:id/edit", PeriodLive.Index, :edit
    live "/periods/:id", PeriodLive.Show, :show
    live "/periods/:id/show/edit", PeriodLive.Show, :edit

    live "/period_groups", PeriodGroupLive.Index, :index
    live "/period_groups/new", PeriodGroupLive.Index, :new
    live "/period_groups/:id/edit", PeriodGroupLive.Index, :edit
    live "/period_groups/:id", PeriodGroupLive.Show, :show
    live "/period_groups/:id/show/edit", PeriodGroupLive.Show, :edit

    live "/signups", SignupLive.Index, :index
    live "/signups/new", SignupLive.Index, :new
    live "/signups/:id/edit", SignupLive.Index, :edit
    live "/signups/:id", SignupLive.Show, :show
    live "/signups/:id/show/edit", SignupLive.Show, :edit

    live "/sites", SiteLive.Index, :index
    live "/sites/new", SiteLive.Index, :new
    live "/sites/:id/edit", SiteLive.Index, :edit
    live "/sites/:id", SiteLive.Show, :show
    live "/sites/:id/show/edit", SiteLive.Show, :edit

    live "/time_slots", TimeSlotLive.Index, :index
    live "/time_slots/new", TimeSlotLive.Index, :new
    live "/time_slots/:id/edit", TimeSlotLive.Index, :edit
    live "/time_slots/:id", TimeSlotLive.Show, :show
    live "/time_slots/:id/show/edit", TimeSlotLive.Show, :edit

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit
    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit
  end

  scope "/", CrewWeb do
    pipe_through [:browser, :public]

    # enter email address: if you're in the system great, if not, that's ok too
    live "/signup", PublicSignupLive.Index, :index
    # either way, you get a magic TOTP link emailed to you and it logs you in as a Person
    live "/signup/confirm_email", PublicSignupLive.ConfirmEmail, :index
    live "/signup/confirm_email/code/:id", PublicSignupLive.ConfirmEmail, :code
    live "/signup/confirm_email/code", PublicSignupLive.ConfirmEmail, :code

    # need a non-live view to make session changes securely
    post "/signup/verify_code", SignupController, :verify_code

    # add/edit your info if anything is missing
    live "/signup/profile", PublicSignupLive.Index, :profile

    # once your profile is complete, you land in the default view, a filterable view of time slots available to you
    live "/time_slots", PublicTimeSlotsLive.Index, :index
    # you pick one and confirm (and later pay, if applicable)
    live "/time_slots/confirm", PublicTimeSlotsLive.Index, :confirm

    delete "/auth/log_out", UserSessionController, :delete
    get "/auth/confirm", UserConfirmationController, :new
    post "/auth/confirm", UserConfirmationController, :create
    get "/auth/confirm/:token", UserConfirmationController, :confirm
  end
end
