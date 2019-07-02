defmodule SumupChallenge.Processing.JobTest do 
  use SumupChallenge.DataCase

  alias SumupChallenge.Processing.Job
  alias SumupChallenge.Processing.Task
  alias SumupChallenge.Processing.Require
  alias SumupChallenge.Processing

  describe "create job/1" do
  @job %{ "tasks" =>  [ 
    %{
      "name" => "task1",
      "command" => "bourdou bou"
    },
    %{
      "name" => "task2",
      "command" => "sardamoubou",
      "requires" => ["task3"]
    },
    %{
      "name" => "task3",
      "command" => "siglakoutela",
      "requires" => ["task1"]
    },
    %{
      "name" => "task4",
      "command" => "rm /tmp/file",
      "requires" => [
        "task2", "task3"
      ]
    }
    ]
    }
 @job2 %{ "tasks" =>  [ 
    %{
      "name" => "task1",
      "command" => "bourdou bou",
      "requires" => ["task2", "task3"]
    },
    %{
      "name" => "task2",
      "command" => "sardamoubou",
      "requires" => []
    },
    %{
      "name" => "task3",
      "command" => "siglakoutela",
      "requires" => ["task2"]
    },
    %{
      "name" => "task4",
      "command" => "rm /tmp/file",
      "requires" => [
        "task2", "task1"
      ]
    }
    ]
    }
  end

  test "insert normal order" do
    assert {:ok, %Job{id: id1} = r_job} = Processing.create_job(@job2)
    job = Processing.get_job!(id1)
    assert length(Processing.list_tasks) == 4

    task1 = List.first(Processing.list_tasks_by_names(["task1"]))
    assert length(task1.require) == 2

    task4 = List.first(Processing.list_tasks_by_names(["task4"]))
    assert length(task4.require) == 2
   
    task3 = List.first(Processing.list_tasks_by_names(["task3"]))
    assert length(task3.require) == 1

  end

  test "execute job" do
    assert {:ok, %Job{id: id}} = Processing.create_job(@job)
    job = Processing.get_job!(id)
    assert length(Processing.list_tasks) == 4

    task_id_list = Processing.execute_job(job)
  
    assert length(task_id_list) == 4
    
    [first | task_id_list] = task_id_list
    assert Processing.get_task!(first).name == "task1"

    [second | task_id_list] = task_id_list
    assert Processing.get_task!(second).name == "task3"

  end

  test "execute job2" do
    assert {:ok, %Job{id: id}} = Processing.create_job(@job2)
    job = Processing.get_job!(id)
    assert length(Processing.list_tasks) == 4

    task_id_list = Processing.execute_job(job)
    
    assert length(task_id_list) == 4
    
    [first | task_id_list] = task_id_list
    assert Processing.get_task!(first).name == "task2"

    [second | task_id_list] = task_id_list
    assert Processing.get_task!(second).name == "task3"
  end

end
