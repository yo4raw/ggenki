defmodule GgenkiWeb.Router do
  use GgenkiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
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
    post "/callback", BotController, :line_callback
    get "/check", BotController, :check
  end

  scope "/", GgemkiWeb do
    pipe_through [:browser, :csrf]
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GgenkiWeb do
  #   pipe_through :api
  # end
end
