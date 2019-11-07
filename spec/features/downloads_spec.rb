require "rails_helper"

describe "downloads" do
  let(:job) { create :job }
  let(:result) { create :result, job: job, name: "my-file" }

  describe "#show" do
    it "renders the page" do
      result

      visit download_path(job)

      expect(page).to have_http_status :success
      expect(page).to have_current_path download_path(job), ignore_query: true
    end
  end
end
