class Jobler::Job < ApplicationJob
  queue_as :jobler

  def perform(_jobler_name)
    raise "stub"
  end
end
