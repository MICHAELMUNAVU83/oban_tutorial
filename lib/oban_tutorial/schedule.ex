defmodule ObanTutorial.Schedule do
  use Oban.Worker, queue: :events, max_attempts: 5
  require Logger
  import Ecto.Query

  alias Oban.Job

  def schedule(args) do
    args
    |> Oban.Job.new(queue: "events", worker: __MODULE__, schedule_in: 5)
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => word}} = job) do
    Logger.debug("got message #{word}")
    IO.inspect(job)
    :ok
  end

  def cancel(key) do
    from(j in Job, where: fragment("? ->> ? = ?", j.args, "id", ^key))
    |> Oban.cancel_all_jobs()
  end

  def test do
    array = [%{id: "word"}, %{id: "word2"}]

    for i <- array do
      schedule(i)
    end
  end
end
