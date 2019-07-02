defmodule SumupChallenge.Processing.Require do
  use Ecto.Schema

  import Ecto.Changeset


  schema "requires" do
    
    belongs_to :require, Task
    belongs_to :task, Task

    timestamps()
  end

  def changeset(requirement, attrs) do
    requirement
    |> cast(attrs, [:require_id, :task_id])
    |> validate_required([:require_id, :task_id])
  end
end
