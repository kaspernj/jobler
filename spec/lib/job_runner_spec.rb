require "rails_helper"

describe Jobler::JobRunner do
  let(:job) { create :job, locale: "da" }
  let(:job_runner) { Jobler::JobRunner.new }

  describe "#perform" do
    it "runs with the correct locale" do
      expect(I18n).to receive(:with_locale).once.with("da").and_call_original

      job_runner.perform(job.id)
    end
  end
end
