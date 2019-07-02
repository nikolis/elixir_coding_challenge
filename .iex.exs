alias SumupChallenge.Processing.Require
alias SumupChallenge.Processing.Job 
alias SumupChallenge.Processing.Task
alias SumupChallenge.Repo
alias SumupChallenge.Processing

import Ecto.Query



job =  %{
 :tasks => [
    %{
      :name => "task-1",
      :command => "touch /tmp/file1"
    },
    %{
      :name => "task-2",
      :command => "cat /tmp/file1",
      :require => [
        "task-3"
      ]
    },
    %{
      :name => "task-3",
      :command => "echo 'Hello World!'> /tmp/file1",
      :require => [
        "task-1"
      ]
    },
    %{
      :name => "task-4",
      :command => "rm /tmp/file1",
      :require => [
        "task-2",
        "task-3"
      ]
    }
  ]
}

task1 = List.last(job.tasks)
job = List.first(Processing.list_jobs())
