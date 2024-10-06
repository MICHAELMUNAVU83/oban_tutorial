defmodule ObanTutorial.Schedule do
  use Oban.Worker, queue: :events, max_attempts: 5
  require Logger
  import Ecto.Query


  alias Oban.Job

  def schedule(schedule_in) do
    %{hello: "word"}
    |> Oban.Job.new([queue: "events", worker: __MODULE__, schedule_in: schedule_in])
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"hello" => hello}} =job) do
    Logger.debug("got message #{hello}")
    IO.inspect(job)
    :ok
  end

  def cancel(key) do
    from(j in Job, where: fragment("? ->> ? = ?", j.args, "hello", ^key))
    |> Oban.cancel_all_jobs()
  end


end
