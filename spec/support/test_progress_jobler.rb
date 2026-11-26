class TestProgressJobler < Jobler::BaseJobler
  # Declares 1000 steps and reports one of them, so the runner has to close the
  # counts out on completion instead of leaving the job at "1 of 1000".
  def execute!
    progress_total 1000
    status_title!("Preparing data")

    increment_progress!
  end

  def result
    Jobler::Message.new(message: "done")
  end
end
