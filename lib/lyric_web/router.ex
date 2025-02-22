defmodule LyricWeb.Router do
  use LyricWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LyricWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LyricWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/songs", SongLive.Index, :index
    live "/songs/new", SongLive.Index, :new
    live "/songs/:id/edit", SongLive.Index, :edit

    live "/songs/:id", SongLive.Show, :show
    live "/songs/:id/show/edit", SongLive.Show, :edit

    live "/games", GameLive.Index
    live "/games/:id", GameLive.Host
    live "/games/:id/join", GameLive.Join
    live "/games/:id/play", GameLive.Play
  end

  # Other scopes may use custom stacks.
  # scope "/api", LyricWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lyric, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LyricWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
