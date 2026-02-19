require "rails_helper"

describe Jobler::JobsController do
  let(:redirect_job) { create :job, jobler_type: "TestRedirectToJob", state: "completed" }
  let(:job) { create :job, status_title: "Resetting Docker server build-node-1" }

  routes { Jobler::Engine.routes }

  it "redirects" do
    get :show, params: {id: redirect_job.to_param}

    expect(response).to redirect_to "/jobler_jobs/#{redirect_job.to_param}"
  end

  it "renders json with headline" do
    get :show, params: {id: job.to_param, format: :json}

    parsed_body = response.parsed_body

    expect(parsed_body.fetch("job")).to include(
      "headline" => "Resetting Docker server build-node-1",
      "status_title" => "Resetting Docker server build-node-1"
    )
  end
end
