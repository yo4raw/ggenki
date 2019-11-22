defmodule Ggenki.Repo.Migrations.Alert do
  use Ecto.Migration

  def change do
    alter table(:alerts) do
      add :message_id, :string, null: false
    end
  end
end
