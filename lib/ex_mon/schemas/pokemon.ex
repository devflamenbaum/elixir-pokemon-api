defmodule ExMon.Schemas.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "pokemons" do
    field :name, :string
    field :nicknaame, :string
    field :weight, :integer
    field :types, {:array, :string}
    belongs_to(:trainer, ExMon.Schemas.Trainer)
    timestamps()
  end

  @required [:name, :nicknaame, :weight, :types, :trainer_id]

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:nicknaame, min: 2)
  end

  def update_changeset(pokemon, params) do
    pokemon
    |> cast(params, [:nicknaame])
    |> validate_required([:nicknaame])
    |> validate_length(:nickname, min: 2)
  end
end
