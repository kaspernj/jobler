class Jobler::PageRender
  def initialize(args)
    @job = args.fetch(:job)
    @name = args.fetch(:name)
  end

  def body
    @job.results.find_by!(name: @name).result
  end
end
