FactoryGirl.define do
  factory :result, class: "Jobler::Result" do
    sequence(:name) { |n| "result-#{n}" }
  end
end
