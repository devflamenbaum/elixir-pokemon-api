defmodule ExMonWeb.Auth.Guardian do
  use Guardian, otp_app: :ex_mon
  alias ExMon.Repo
  alias ExMon.Schemas.Trainer

  def subject_for_token(trainer, _claims) do
    sub = to_string(trainer.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> ExMon.fetch_trainer()
  end

  def authenticate(%{"id" => trainer_id, "password" => trainer_password}) do
    case Repo.get(Trainer, trainer_id) do
      nil -> {:error, "Trainer not found"}
      trainer -> validate_password(trainer, trainer_password)
    end
  end

  def validate_password(%{password_hash: hash} = trainer, password) do
    case Pbkdf2.verify_pass(password, hash) do
      true -> create_token(trainer)
      false -> {:error, :unathorized}
    end
  end

  defp create_token(trainer) do
    {:ok, token, _claims} = encode_and_sign(trainer)
    {:ok, token}
  end
end
