defmodule Ggenki.Repo.Migrations.AlertsMessageIdType do
  use Ecto.Migration

  def change do
    alter table(:alerts) do
      modify :message_id, :integer
    end
  end
end
