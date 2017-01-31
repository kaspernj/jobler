class Jobler::FileDownload
  attr_reader :file_name, :temp_file

  def initialize(args)
    @file_name = args.fetch(:file_name)
    @temp_file = args.fetch(:temp_file)
  end
end
