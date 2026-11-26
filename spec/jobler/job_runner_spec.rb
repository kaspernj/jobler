require "rails_helper"

describe Jobler::JobRunner do
  let(:job) { create :job, locale: "da" }
  let(:job_with_error) { create :job, jobler_type: "TestErrorJobler" }
  let(:job_with_error_callback) { create :job, jobler_type: "TestOnErrorJobler" }
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

    it "closes out the progress counts when the job completes" do
      job_with_progress = create :job, jobler_type: "TestProgressJobler"

      job_runner.perform(job_with_progress.id)

      expect(job_with_progress.reload).to have_attributes(
        progress: 1.0,
        progress_current_count: 1000,
        progress_total_count: 1000,
        state: "completed",
        status_title: "Preparing data"
      )
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

    it "calls on_error callbacks with the exception, after the failure has been recorded on the job" do
      job_runner.perform(job_with_error_callback.id)

      expect(job_with_error_callback.reload).to have_attributes(
        state: "error",
        error_message: "on error callback",
        error_type: "ArgumentError",
        status_title: "ArgumentError: on error callback: error: ArgumentError"
      )
    end

    it "does not call on_error callbacks when the job completes" do
      job_runner.perform(job.id)

      expect(job.reload.status_title).to be_nil
    end
  end
end
