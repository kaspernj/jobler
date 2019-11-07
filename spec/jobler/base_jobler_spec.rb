require "rails_helper"

describe Jobler::BaseJobler do
  let(:job) { create :job, jobler_type: "TestRenderJobler" }
  let(:test_render_jobler) { job.jobler }

  describe "#render" do
    it "renders templates" do
      content = test_render_jobler.render(:show)

      expect(content).to include "https://jobler.test.host:1234/jobler_jobs/#{job.to_param}"
    end
  end
end
