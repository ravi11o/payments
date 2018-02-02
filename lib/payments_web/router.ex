defmodule PaymentsWeb.Router do
  use PaymentsWeb, :router

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

  scope "/", PaymentsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/payment", PageController, :process_payment
    post "/payment-confirmation", PageController, :confirm_payment
  end

  # Other scopes may use custom stacks.
  # scope "/api", PaymentsWeb do
  #   pipe_through :api
  # end
end
