class Jobler::Models::DestroyerJobler < Jobler::BaseJobler
  def execute!
    calculate_numbers

    model_class.transaction do
      destroy_relationships
    end
  end

  def result
    format.html { controller.redirect_to args.fetch(:redirect_to) }
  end

private

  def calculate_numbers
    Rails.logger.debug "Calculate numbers"

    @total = 0
    relationships.each do |relationship|
      Rails.logger.debug "Calculate size for #{relationship}"
      @total += model.__send__(relationship).size
    end

    progress_total @total

    Rails.logger.debug "Done calculating numbers: #{@total}"
  end

  def destroy_relationships
    Rails.logger.debug "Destroying relationships"
    relationships.each do |relationship|
      Rails.logger.debug "Destroying #{relationship}"
      model.__send__(relationship).find_each do |sub_model|
        Rails.logger.debug "Destroying #{sub_model.id}"
        sub_model.destroy!
        increment_progress!
      end
    end
  end

  def model_class
    @model_class ||= args.fetch(:model).constantize
  end

  def model
    @_model ||= Project.find(args.fetch(:model_id))
  end

  def relationships
    @_relationships ||= proc do
      result = []

      model_class.reflections.each_value do |reflection|
        next unless reflection.is_a?(ActiveRecord::Reflection::HasManyReflection)
        next unless reflection.options[:dependent] == :destroy

        result << reflection.name
      end

      result
    end.call
  end
end
