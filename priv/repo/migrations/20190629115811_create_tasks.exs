defmodule SumupChallenge.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :command, :string


      add :job_id, references(:jobs, on_delete: :nothing)
      add :parent_id, references(:tasks, on_delete: :nothing)


      timestamps()
    end

    create index(:tasks, [:job_id])
    create unique_index(:tasks, [:name])
  end
end
