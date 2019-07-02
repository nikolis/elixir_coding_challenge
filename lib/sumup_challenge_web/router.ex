defmodule SumupChallengeWeb.Router do
  use SumupChallengeWeb, :router

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

  scope "/", SumupChallengeWeb do
    pipe_through :api

    get "/", PageController, :index
    resources "/jobs", JobController, only: [:create, :show, :update, :delete, :index]
    get "/jobs/execution/:id", JobController, :get_executable_job
  end

  # Other scopes may use custom stacks.
  # scope "/api", SumupChallengeWeb do
  #   pipe_through :api
  # end
end
