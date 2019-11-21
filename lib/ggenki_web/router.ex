defmodule GgenkiWeb.Router do
  use GgenkiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  pipeline :csrf do
    plug :protect_from_forgery
  end
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GgenkiWeb do
    pipe_through :browser
    get "/", PageController, :index
    post "/callback", BotController, :line_callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", GgenkiWeb do
  #   pipe_through :api
  # end
end
