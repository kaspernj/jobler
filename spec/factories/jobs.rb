FactoryBot.define do
  factory :job, class: "Jobler::Job" do
    host { "jobler.test.host" }
    jobler_type { "TestJobler" }
    parameters { YAML.dump({}) }
    port { 1234 }
    protocol { "https" }
  end
end
