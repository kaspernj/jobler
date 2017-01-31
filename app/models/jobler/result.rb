class Jobler::Result < ActiveRecord::Base
  belongs_to :job, class_name: "Jobler::Job"

  validates :job, :name, presence: true
end
