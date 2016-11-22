defmodule FlaskOnPhoenix.Router do
  use FlaskOnPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlaskOnPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", FlaskOnPhoenix do
    pipe_through :api

    # 付箋一覧取得(:index)
    get  "/stickys", StickyController, :index
  end
end
