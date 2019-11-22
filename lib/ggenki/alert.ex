defmodule Ggenki.Alert do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "alerts" do
    field :message_id, :integer
    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [])
    |> validate_required([])
  end

  def get_by_message(alert, message_id) do
    from(a in alert,
      where: a.message_id == ^message_id,
      limit: 1)
  end
end
