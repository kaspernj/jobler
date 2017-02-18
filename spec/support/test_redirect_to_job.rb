class TestRedirectToJob < Jobler::BaseJobler
  def execute!
    raise "stub"
  end

  def result
    Jobler::RedirectTo.new(url: "/jobler_jobs/#{job.to_param}")
  end
end
