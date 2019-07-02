defmodule SumupChallenge.TestHelpers do
  
  alias SumupChallenge.Processing.{
    Task,
    Job,
    Require
  }


  def task_fixture(attrs \\ %{}) do
    numb = System.unique_integer([:positive])

    name = "task#{numb}"
    req_name_1 = "task#{numb + 1}"
    req_name_2 = "task#{numb + 2}"

    {:ok, task} = 
      attrs
      |> Enum.into(%{
        name: name,
        require: [
          req_name_1, 
          req_name_2
        ] 
      })
  end

end
