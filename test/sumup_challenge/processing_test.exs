defmodule SumupChallenge.ProcessingTest do
  use SumupChallenge.DataCase

  alias SumupChallenge.Processing

  describe "jobs" do
    alias SumupChallenge.Processing.Job

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def job_fixture(attrs \\ %{}) do
      {:ok, job} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Processing.create_job()

      job
    end

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Processing.list_jobs() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Processing.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      assert {:ok, %Job{} = job} = Processing.create_job(@valid_attrs)
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Processing.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      assert {:ok, %Job{} = job} = Processing.update_job(job, @update_attrs)
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Processing.update_job(job, @invalid_attrs)
      assert job == Processing.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Processing.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Processing.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Processing.change_job(job)
    end
  end

  describe "tasks" do
    alias SumupChallenge.Processing.Task

    @valid_attrs %{command: "some command", name: "some name"}
    @update_attrs %{command: "some updated command", name: "some updated name"}
    @invalid_attrs %{command: nil, name: nil}


    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Processing.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Processing.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Processing.create_task(@valid_attrs)
      assert task.command == "some command"
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Processing.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Processing.update_task(task, @update_attrs)
      assert task.command == "some updated command"
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Processing.update_task(task, @invalid_attrs)
      assert task == Processing.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Processing.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Processing.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Processing.change_task(task)
    end
  end
end
