defmodule Ggenki.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "messages" do
    field :body, :string
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user, :body])
    |> validate_required([:user, :body])
  end

  def latest_comment_by_user(message, user) do
    from(m in message,
    where: m.user == ^user,
    order_by: [desc: m.inserted_at],
    limit: 1)
  end
end
