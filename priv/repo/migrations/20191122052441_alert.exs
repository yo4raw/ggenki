defmodule Ggenki.Repo.Migrations.Alerts do
  use Ecto.Migration

  def change do
    alter table(:alerts) do
      add :message_id, :string, null: false
    end
  end
end
