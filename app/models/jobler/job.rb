class Jobler::Job < ActiveRecord::Base
  has_many :results, class_name: "Jobler::Result", dependent: :destroy

  validates :jobler_type, :state, presence: true

  def jobler
    user_jobler = jobler_type.constantize.new
    user_jobler.instance_variable_set(:@args, YAML.load(parameters)) # rubocop:disable Security/YAMLLoad
    user_jobler.instance_variable_set(:@job, self)
    user_jobler
  end

  def completed?
    state == "completed"
  end
end
