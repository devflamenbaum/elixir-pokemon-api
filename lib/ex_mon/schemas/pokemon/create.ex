defmodule ExMon.Schemas.Pokemon.Create do
  alias ExMon.PokeApi.Client
  alias ExMon.Schemas.Pokemon, as: TrainerPokemon
  alias ExMon.Schemas.Trainer
  alias ExMon.Pokemon
  alias ExMon.Repo
  alias Ecto.UUID

  def call(%{"name" => name} = params) do
    name
    |> Client.get_pokemon()
    |> handle_response(params)
  end

  defp handle_response({:ok, body},params) do
    body
    |> Pokemon.build()
    |> create_pokemon(params)
  end

  defp handle_response({:error, _msg} = error, _params), do: error

  defp create_pokemon(%Pokemon{name: name, weight: weight, types: types}, %{"nicknaame" => nicknaame, "trainer_id" => trainer_id}) do
    params = %{
      name: name,
      weight: weight,
      types: types,
      nicknaame: nicknaame,
      trainer_id: trainer_id
    }
    case UUID.cast(trainer_id) do
      :error -> {:error, "Invalid Trainer ID format!"}
      {:ok, _trainer_id} -> get_trainer(trainer_id,params)
    end
  end

  defp get_trainer(trainer_id,params) do
    case fetch_trainer(trainer_id) do
      nil -> {:error, "Trainer not found!"}
      _trainer -> insert_pokemon(params)
    end
  end

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp insert_pokemon(params) do
    params
    |> TrainerPokemon.build()
    |> handle_build()
  end

  defp handle_build({:ok, pokemon}), do: Repo.insert(pokemon)
  defp handle_build({:error, _changeset} = error), do: error
end
