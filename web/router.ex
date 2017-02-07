
defmodule Callforpapers.Router do
  use Callforpapers.Web, :router

  import Callforpapers.Auth, only: [authenticate_user: 2, authenticate_organizer: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Callforpapers.Auth, repo: Callforpapers.Repo
  end

  pipeline :registered_users do
    plug :authenticate_user
  end

  pipeline :organizers do
    plug :authenticate_organizer
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Callforpapers do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :delete, :create]
  end

  scope "/", Callforpapers do
    pipe_through [:browser, :registered_users]

    resources "/users", UserController, only: [:show, :index, :edit, :delete, :update]
    resources "/talks", TalkController
    resources "/submissions", SubmissionController
    #  do
    #   post "/acceptance", SubmissionController, :accept, as: :accept
    #   post "/rejection", SubmissionController, :reject, as: :reject
    # end
    resources "/callforpapers", CallforpapersController, only: [:show, :index]
  end

  scope "/", Callforpapers do
    pipe_through [:browser, :organizers]

    resources "/submissions", SubmissionController, only: [:accept, :reject] do
      post "/acceptance", SubmissionController, :accept, as: :accept
      post "/rejection", SubmissionController, :reject, as: :reject
    end
  end

  scope "/organization/", Callforpapers do
    pipe_through [:browser, :registered_users, :organizers] # Use the default browser stack

    resources "/conferences", ConferenceController
    resources "/callforpapers", CallforpapersController, only: [:edit, :delete, :update, :create, :new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Callforpapers do
  #   pipe_through :api
  # end
end
