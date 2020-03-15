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
  end

  describe "#render" do
    it "renders templates" do
      content = test_render_jobler.render(:show)

      expect(content).to include "https://jobler.test.host:1234/jobler_jobs/#{job.to_param}"
    end
  end
end
