defmodule SumupChallenge.Repo.Migrations.CreateRequire do
  use Ecto.Migration

  def change do
    create table(:requires) do
      add :task_id, references(:tasks, on_delete: :delete_all), primary_key: true
      add :require_id, references(:tasks, on_delete: :nothing), primary_key: true

      timestamps()
    end
  end
end
