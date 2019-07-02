defmodule SumupChallenge.Processing.TaskTest do 
  use SumupChallenge.DataCase

  alias SumupChallenge.Processing
  alias SumupChallenge.Processing.Task

  describe "create task/1" do
    @task1 %{
      name:  "task1",
      command: "bourdou bou",
      require: ["task2", "task3"]
    }

    @task2 %{
      name: "task2",
      command: "sardamoubou",
      require: []
    }

    @task3 %{
      name: "task3",
      command: "siglakoutela",
      require: ["task2"]
    }
  end


  test "insert normal order" do
    assert {:ok, %Task{id: id1} = r_task1} = Processing.create_task(@task1)
    assert length(Processing.list_tasks) == 3 
    assert {:ok, %Task{id: id2} = r_task2} = Processing.create_task(@task2)
    assert length(Processing.list_tasks) == 3
    assert {:ok, %Task{id: id3} = r_task3} = Processing.create_task(@task3)
    assert length(Processing.list_tasks) == 3
  end





end
