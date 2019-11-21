defmodule Ggenki.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  schema "alerts" do

    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [])
    |> validate_required([])
  end
end
