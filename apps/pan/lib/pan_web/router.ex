defmodule PanWeb.Router do
  use PanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PanWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PanWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/hello/:name", HelloController, :world
    get "/hello", HelloController, :world

    resources "/shows", ShowController, only: [:index, :show]

    resources "/venues", VenueController, only: [:index, :show]

    resources "/bands", BandController, only: [:index, :show]

    resources "/users", UserController, only: [:index, :show, :new, :create]
    # get "/users", UserController, :index
    # get "/users/:id", UserController, :show

    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PanWeb do
  #   pipe_through :api
  # end
end
