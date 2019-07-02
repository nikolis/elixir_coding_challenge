defmodule SumupChallengeWeb.TaskView do
  use SumupChallengeWeb, :view
  alias SumupChallengeWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      name: task.name,
      command: task.command,
      requires: render_many(task.require, TaskView, "tasksimple.json")
     }
  end

  def render("tasksimple.json", %{task: task}) do
    %{id: task.id,
      name: task.name,
      command: task.command,
     }
  end

end
