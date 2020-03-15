class Jobler::FileDownload
  attr_reader :file_name, :temp_file, :url

  def initialize(file_name:, temp_file: nil, url:)
    @file_name = file_name
    @temp_file = temp_file
    @url = url
  end
end
