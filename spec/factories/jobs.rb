FactoryGirl.define do
  factory :job, class: "Jobler::Job" do
    jobler_type "TestJobler"
    parameters YAML.dump({})
  end
end
