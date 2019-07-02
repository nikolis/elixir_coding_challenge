defmodule SumupChallengeWeb.JobController do
  use SumupChallengeWeb, :controller

  alias SumupChallenge.Processing
  alias SumupChallenge.Processing.Job
  alias SumupChallenge.Repo

  action_fallback SumupChallengeWeb.FallbackController

  def index(conn, _params) do
    jobs = Processing.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, job_params) do
    with {:ok, %Job{} = job} <- Processing.create_job(job_params) do
      job = Repo.preload(job, [{:tasks, :require}])
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Processing.get_job!(id)
    id_ordered_list = Processing.execute_job(job)
    commands = Enum.map(id_ordered_list, fn id ->
      task =  Processing.get_task!(id)
      task
    end)
    job = Map.put(job, :tasks, commands)
    render(conn, "show.json", job: job)
  end

  def pretty_json(conn, data) do
    conn
      |> Plug.Conn.put_resp_header("content-type", "application/json; charset=utf-8")
      |> Plug.Conn.send_resp(200, Poison.encode!(data, pretty: true))
  end

  def get_executable_job(conn, %{"id" => id}) do
    job = Processing.get_job!(id)
    id_ordered_list = Processing.execute_job(job)
    commands = Enum.map(id_ordered_list, fn id ->
       task =  Processing.get_task!(id)
       task.command
    end)
    pretty_json(conn, commands)
  end


  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Processing.get_job!(id)
    
    with {:ok, %Job{} = job} <- Processing.update_job(job, job_params) do
      render(conn, "show.json", job: job)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Processing.get_job!(id)

    with {:ok, %Job{}} <- Processing.delete_job(job) do
      send_resp(conn, :no_content, "")
    end
  end
end
