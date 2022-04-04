defmodule ExMonWeb.Router do
  use ExMonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ExMon.Auth.Pipeline
  end

  scope "/api", ExMonWeb do
    pipe_through :api

    post "/trainers", TrainersController, :create

    get "/pokemons/:name", PokemonsController, :show
    post "/trainers/signin", TrainersController, :sign_in
  end

  scope "/api", ExMonWeb do
    pipe_through [:api, :auth]

    resources "/trainers", TrainersController, only: [:show, :delete, :update]
    resources "/trainer_pokemon", TrainerPokemonController, only: [:create, :show, :delete, :update]

  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ExMonWeb.Telemetry
    end

    scope "/", ExMonWeb do
      pipe_through :api

      get "/", WelcomeController, :index
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
