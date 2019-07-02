defmodule SumupChallenge.Processing.Task do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias SumupChallenge.Processing.Require
  alias SumupChallenge.Processing.Job 
  alias SumupChallenge.Processing 
  #alias SumupChallenge.Repo

  schema "tasks" do
    field :command, :string
    field :name, :string
 
    #has_many :require, SumupChallenge.Processing.Task, foreign_key: :parent_id 
 
    belongs_to :job, Job 
    many_to_many :require, SumupChallenge.Processing.Task, join_through: "requires", 
    join_keys: [task_id: :id, require_id: :id]

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :command, :job_id])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end



end 
