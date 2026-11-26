require "rails_helper"

describe Jobler::BaseJobler do
  let(:job) { create :job, jobler_type: "TestRenderJobler" }
  let(:test_render_jobler) { job.jobler }

  describe "#create_result" do
    it "creates a result with given raw content" do
      result = test_render_jobler.create_result!(
        content: "Hello world",
        name: "Test"
      )

      expect(result.file).to be_attached
      expect(result.file.download).to eq "Hello world"
      expect(result.name).to eq "Test"
    end

    it "creates a result with the given result" do
      result = test_render_jobler.create_result!(
        name: "test",
        result: "hejsa"
      )

      expect(result).to have_attributes(
        name: "test",
        result: "hejsa"
      )
    end
  end

  describe "#render" do
    it "renders templates" do
      content = test_render_jobler.render(:show)

      expect(content).to include "https://jobler.test.host:1234/jobler_jobs/#{job.to_param}"
    end
  end

  describe "#progress_total" do
    it "stores the total so a frontend can show how many steps the job has" do
      test_render_jobler.progress_total(200)

      expect(job.reload).to have_attributes(
        progress_current_count: 0,
        progress_total_count: 200
      )
    end
  end

  describe "#increment_progress!" do
    it "counts steps and turns them into a fraction once a total is known" do
      test_render_jobler.progress_total(100)

      10.times do
        test_render_jobler.increment_progress!
      end

      expect(job.reload).to have_attributes(
        progress_current_count: 10,
        progress_total_count: 100
      )
      expect(job.progress).to be_within(0.0001).of(0.1)
    end

    it "counts steps even when no total has been declared" do
      test_render_jobler.increment_progress!

      expect(job.reload).to have_attributes(
        progress_current_count: 1,
        progress_total_count: 0
      )
    end

    it "keeps progress at zero for a zero total instead of writing a NaN" do
      test_render_jobler.progress_total(0)
      test_render_jobler.increment_progress!

      expect(job.reload.progress).to eq(0.0)
    end

    it "writes progress about once per percent instead of once per step" do
      allow(job).to receive(:update!).and_call_original

      test_render_jobler.progress_total(1000)

      1000.times do
        test_render_jobler.increment_progress!
      end

      expect(job).to have_received(:update!).at_most(101).times
      expect(job.reload).to have_attributes(
        progress_current_count: 1000,
        progress_total_count: 1000
      )
    end
  end

  describe "#status_title!" do
    it "updates the jobs status title" do
      test_render_jobler.status_title!("Preparing data")

      expect(job.reload).to have_attributes(
        status_title: "Preparing data"
      )
    end

    it "updates the status title when the text changes" do
      test_render_jobler.status_title!("Preparing data")
      test_render_jobler.status_title!("Deleting removed products")

      expect(job.reload.status_title).to eq("Deleting removed products")
    end

    it "does not write the status title again while the text is unchanged" do
      test_render_jobler.status_title!("Preparing data")
      updated_at = job.reload.updated_at

      5.times do
        test_render_jobler.status_title!("Preparing data")
      end

      expect(job.reload.updated_at).to eq(updated_at)
    end
  end
end
