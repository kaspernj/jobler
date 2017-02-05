require "rails_helper"

describe Jobler::BaseJobler do
  let(:test_render_jobler) { TestRenderJobler.new }

  describe "#render" do
    it "renders templates" do
      content = test_render_jobler.render(:show)

      expect(content).to eq "Test\n"
    end
  end
end
