require "rails_helper"

describe Jobler::JobsController do
  let(:redirect_job) { create :job, jobler_type: "TestRedirectToJob", state: "completed" }

  routes { Jobler::Engine.routes }

  it "redirects" do
    get :show, params: {id: redirect_job.to_param}

    expect(response).to redirect_to "/jobler_jobs/#{redirect_job.to_param}"
  end
end
