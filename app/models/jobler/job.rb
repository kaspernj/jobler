class Jobler::Job < ActiveRecord::Base
  has_many :results, class_name: "Jobler::Result", dependent: :destroy

  validates :jobler_type, :slug, :state, presence: true

  before_validation :set_slug

  def jobler
    user_jobler = jobler_type.constantize.new
    user_jobler.instance_variable_set(:@args, YAML.load(parameters)) # rubocop:disable Security/YAMLLoad
    user_jobler.instance_variable_set(:@job, self)
    user_jobler
  end

  def completed?
    state == "completed"
  end

  def error?
    state == "error"
  end

  def to_param
    raise "No slug" unless slug?
    slug
  end

private

  def set_slug
    require "securerandom"
    self.slug ||= SecureRandom.hex
  end
end
