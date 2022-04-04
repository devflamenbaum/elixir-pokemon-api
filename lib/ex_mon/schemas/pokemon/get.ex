defmodule ExMon.Schemas.Pokemon.Get do
  alias ExMon.Schemas.Pokemon
  alias ExMon.Repo
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format!"}
      {:ok, uuid} -> get_pokemon(uuid)
    end
  end

  defp get_pokemon(uuid) do
    case Repo.get(Pokemon,  uuid) do
      nil -> {:error, "Pokemon not found!"}
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)}
    end
  end
end
