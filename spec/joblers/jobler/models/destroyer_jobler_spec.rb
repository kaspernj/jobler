require "rails_helper"

describe Jobler::Models::DestroyerJobler do
  let!(:job) { create :job }
  let!(:result) { create :result, job: job, name: "my-file" }

  it "deletes the record" do
    expect do
      expect do
        perform_enqueued_jobs do
          Jobler::JobScheduler.create!(
            jobler_type: "Jobler::Models::DestroyerJobler",
            job_args: {model: "Jobler::Job", model_id: job.id, redirect_to: "/"}
          )
        end
      end.to change(Jobler::Job, :count).by(0)
    end.to change(Jobler::Result, :count).by(-1)

    expect { job.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
