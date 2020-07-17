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
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrewWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/organizations", OrganizationLive.Index, :index
    live "/organizations/new", OrganizationLive.Index, :new
    live "/organizations/:id/edit", OrganizationLive.Index, :edit
    live "/organizations/:id", OrganizationLive.Show, :show
    live "/organizations/:id/show/edit", OrganizationLive.Show, :edit

    live "/persons", PersonLive.Index, :index
    live "/persons/new", PersonLive.Index, :new
    live "/persons/:id/edit", PersonLive.Index, :edit
    live "/persons/:id", PersonLive.Show, :show
    live "/persons/:id/show/edit", PersonLive.Show, :edit

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit
    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit
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

  scope "/", CrewWeb do
    # disable auth for now
    # pipe_through [:browser, :require_authenticated_user]
    pipe_through [:browser]

    live "/sites", SiteLive.Index, :index
    live "/sites/new", SiteLive.Index, :new
    live "/sites/:id/edit", SiteLive.Index, :edit

    live "/sites/:id", SiteLive.Show, :show
    live "/sites/:id/show/edit", SiteLive.Show, :edit
  end

  scope "/", CrewWeb do
    pipe_through [:browser]

    delete "/auth/log_out", UserSessionController, :delete
    get "/auth/confirm", UserConfirmationController, :new
    post "/auth/confirm", UserConfirmationController, :create
    get "/auth/confirm/:token", UserConfirmationController, :confirm
  end
end
