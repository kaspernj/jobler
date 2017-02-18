class Jobler::RedirectTo
  attr_reader :url

  def initialize(args)
    @url = args.fetch(:url)
  end
end
