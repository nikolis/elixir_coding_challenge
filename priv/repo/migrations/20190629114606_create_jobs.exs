defmodule SumupChallenge.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do

      timestamps()
    end

  end
end
