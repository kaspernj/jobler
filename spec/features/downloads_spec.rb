require "rails_helper"

path = File.realpath("spec/fixtures/test.csv")
puts "Path: #{path}"

describe "downloads" do
  let(:job) { create :job }
  let(:result) { create :result, job: job, name: "my-file" }
  let(:result_with_file) { create :result, file: fixture_file_upload(path), job: job, name: "my-file", result: nil }

  describe "#show" do
    it "renders the page" do
      result

      visit download_path(job)

      expect(page).to have_http_status :success
      expect(page).to have_current_path download_path(job), ignore_query: true
    end

    it "renders the page with an ActiveStorage attachment" do
      result_with_file

      visit download_path(job)

      expect(page).to have_http_status :success
      expect(page).to have_current_path download_path(job), ignore_query: true
    end
  end
end
