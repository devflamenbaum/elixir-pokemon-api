defmodule ExMonWeb.TrainerPokemonView do
  use ExMonWeb, :view

  alias ExMon.Schemas.Pokemon

  def render("create.json",
            %{pokemon: %Pokemon{
              id: id,
              name: name,
              inserted_at: inserted_at,
              nicknaame: nicknaame,
              types: types,
              trainer_id: trainer_id,
              weight: weight}}) do

    %{
      message: "Pokemon Created!",
      pokemon: %{
        id: id,
        name: name,
        inserted_at: inserted_at,
        nicknaame: nicknaame,
        types: types,
        trainer_id: trainer_id,
        weight: weight
      }
    }
  end

   def render("show.json",
            %{pokemon: %Pokemon{
              id: id,
              name: name,
              inserted_at: inserted_at,
              nicknaame: nicknaame,
              types: types,
              trainer: %{
                id: trainer_id,
                name: trainer_name
              },
              weight: weight}}) do

    %{
      pokemon: %{
        id: id,
        name: name,
        inserted_at: inserted_at,
        nicknaame: nicknaame,
        types: types,
        trainer: %{ id: trainer_id, name: trainer_name},
        weight: weight
      }
    }
  end

  def render("update.json",
            %{pokemon: %Pokemon{
              id: id,
              name: name,
              inserted_at: inserted_at,
              nicknaame: nicknaame,
              types: types,
              trainer_id: trainer_id,
              weight: weight}}) do

    %{
      message: "Pokemon Update!",
      pokemon: %{
        id: id,
        name: name,
        inserted_at: inserted_at,
        nicknaame: nicknaame,
        types: types,
        trainer_id: trainer_id,
        weight: weight
      }
    }
  end
end
