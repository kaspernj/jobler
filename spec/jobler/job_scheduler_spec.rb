require "rails_helper"

describe Jobler::JobScheduler do
  let(:scheduler) { Jobler::JobScheduler.new(jobler_type: "TestJobler") }

  describe "#create_job" do
    it "uses the default locale if none is given" do
      I18n.with_locale(:da) do
        expect do
          scheduler.create_job
        end.to change(Jobler::Job, :count).by(1)
      end

      created_job = Jobler::Job.last

      expect(created_job.locale).to eq "da"
    end

    it "persists status title when given" do
      scheduler_with_title = Jobler::JobScheduler.new(
        jobler_type: "TestJobler",
        status_title: "Activating docker server"
      )

      scheduler_with_title.create_job

      expect(Jobler::Job.last!).to have_attributes(
        status_title: "Activating docker server"
      )
    end
  end
end
