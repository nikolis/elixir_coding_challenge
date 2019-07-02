defmodule SumupChallengeWeb.PageController do
  use SumupChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
