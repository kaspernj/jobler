require "rails_helper"

describe Jobler::BaseJobler do
  let(:job) { create :job, jobler_type: "TestRenderJobler" }
  let(:test_render_jobler) { job.jobler }

  describe "#render" do
    it "renders templates" do
      content = test_render_jobler.render(:show)

      expect(content).to eq "Test\n"
    end
  end
end
