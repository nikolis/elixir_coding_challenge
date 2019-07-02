defmodule SumupChallenge.Processing.Job do
  use Ecto.Schema

  import Ecto.Changeset
  alias SumupChallenge.Processing.Task 

  schema "jobs" do

    has_many :tasks, Task

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [])
    |> validate_required([:tasks])
  end
end
