class Jobler::Result < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  belongs_to :job, class_name: "Jobler::Job", inverse_of: :results

  has_one_attached :file

  validates :name, presence: true
end
