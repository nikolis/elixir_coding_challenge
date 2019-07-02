defmodule SumupChallengeWeb.JobView do
  use SumupChallengeWeb, :view
  alias SumupChallengeWeb.JobView
  alias SumupChallengeWeb.TaskView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("execution.json", command_list) do
    %{
      commands: command_list
    }
  end

  def render("command.json", command) do
    command
  end
  def render("job.json", %{job: job}) do
    %{
      id: job.id,
      tasks: render_many(job.tasks, TaskView, "task.json") 
    }

  end
end
