require "rails_helper"

describe Jobler::JobRunner do
  let(:job) { create :job, locale: "da" }
  let(:job_with_error) { create :job, jobler_type: "TestErrorJobler" }
  let(:job_runner) { Jobler::JobRunner.new }

  describe "#perform" do
    it "runs with the correct locale" do
      expect(I18n).to receive(:with_locale).once.with("da").and_call_original

      job_runner.perform(job.id)

      job.reload

      expect(job.error_message).to be_nil
      expect(job.error_type).to be_nil
      expect(job.error_backtrace).to be_nil
      expect(job.state).to eq "completed"
    end

    it "logs errors on the job" do
      job_runner.perform(job_with_error.id)
      job_with_error.reload

      expect(job_with_error).to have_attributes(
        state: "error",
        error_message: "test",
        error_type: "RuntimeError",
        protocol: "after-called",
        slug: "before-called"
      )
    end
  end
end
