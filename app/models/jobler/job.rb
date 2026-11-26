class Jobler::Job < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  has_many :results, class_name: "Jobler::Result", dependent: :destroy, inverse_of: :job

  validates :jobler_type, :slug, :state, presence: true

  before_validation :set_slug

  def jobler
    @jobler ||= jobler_type.constantize.new(args: YAML.load(parameters), job: self) # rubocop:disable Security/YAMLLoad
  end

  def completed?
    state == "completed"
  end

  def error?
    state == "error"
  end

  # False in apps that have not installed 20261126090000_add_progress_counts_to_jobler_jobs yet.
  def progress_counts_available?
    has_attribute?(:progress_current_count) && has_attribute?(:progress_total_count)
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
