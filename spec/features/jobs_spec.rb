require "rails_helper"

describe "jobs" do
  let(:job) { create :job }

  describe "#show" do
    it "renders the page" do
      visit job_path(job)

      expect(page).to have_http_status :success
      expect(current_path).to eq job_path(job)
    end
  end
end
