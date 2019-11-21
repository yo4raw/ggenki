defmodule Ggenki.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    create table(:alerts) do

      timestamps()
    end

  end
end
