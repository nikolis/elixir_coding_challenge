defmodule SumupChallenge.Processing do
  @moduledoc """
  The Processing context.
  """

  import Ecto.Query, warn: false
  alias SumupChallenge.Repo

  alias SumupChallenge.Processing.Job
  alias SumupChallenge.Processing.Require

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs do
    Repo.all(Job)
    |> Repo.preload([
      {:tasks,
        :require
      }
    ])
  end

  def execute_job(%{tasks: tasks}) do
    graph = :digraph.new()
    Enum.each(tasks, fn task -> 
      :digraph.add_vertex(graph, task.id)
    end)
    Enum.each(tasks, fn task ->
      Enum.each(task.require, fn r_task ->
        {first, _} = :digraph.vertex(graph, task.id)
        {second, _} = :digraph.vertex(graph, r_task.id)
        :digraph.add_edge(graph, first, second)
      end)
    end)
    :digraph_utils.postorder(graph)
  end


  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id) do 
    Repo.get!(Job, id)
    |> Repo.preload([
      {:tasks,
        :require
      }
    ])
  end

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    {tasks, attrs} = Map.pop(attrs, "tasks", [])
    result = %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
    case result do 
      {:ok, job} ->
        Enum.each(tasks, fn task ->
          create_task(Map.put(task, "job_id", job.id))
        end)
        {:ok, job}
      _ ->
        result
    end
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{source: %Job{}}

  """
  def change_job(%Job{} = job) do
    Job.changeset(job, %{})
  end

  alias SumupChallenge.Processing.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task) 
    |> Repo.preload :require
  end

  def list_tasks_by_names(names) do
    Repo.all(from t in Task, where: t.name in ^ names)
    |> Repo.preload :require
  end


  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Repo.get!(Task, id)
    |>Repo.preload(:require)
  end


  def create_task(attrs \\ %{}) do

    {tasks, attrs} = Map.pop(attrs, "requires", [])
    
    name = attrs["name"]
    task_or = list_tasks_by_names([name])

    {:ok, task}=case task_or do
      [item] ->
        attrs  = Map.put(attrs, "id", item.id)
        %Task{id: item.id}  
          |> Task.changeset(attrs)
          |> Repo.update
      [] ->
        %Task{}
          |> Task.changeset(attrs) 
          |> Repo.insert()
    end

    new_tasks = Enum.map(tasks, fn task_name ->
      task_temp = list_tasks_by_names([task_name])
      {:ok, task_inner} =case task_temp do
        [item] ->
          %Task{id: item.id}
          |> Task.changeset(%{name: task_name, id: item.id })
          |> Repo.update()
        [] ->
          %Task{}
          |> Task.changeset(%{name: task_name})
          |> Repo.insert()        
      end
        %Require{}
        |> Require.changeset(%{"task_id" => task.id, "require_id" => task_inner.id})
        |> Repo.insert() 
    end)
    {:ok, task}
 end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
