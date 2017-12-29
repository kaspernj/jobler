class Jobler::Result < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  belongs_to :job, class_name: "Jobler::Job", inverse_of: :results

  validates :job, :name, presence: true
end
