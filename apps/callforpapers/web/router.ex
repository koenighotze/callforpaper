defmodule Callforpapers.Router do
  use Callforpapers.Web, :router

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

  scope "/", Callforpapers do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/presenters", PresenterController
    resources "/submissions", SubmissionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Callforpapers do
  #   pipe_through :api
  # end
end