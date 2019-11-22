defmodule Ggenki.Message do
  use Ecto.Schema
  import Ecto.Changeset

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
    from c in message,
    where: c.user == ^user,
    order_by: [desc: c.inserted_at]
  end
end
