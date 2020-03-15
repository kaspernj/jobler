class Jobler::FileDownload
  attr_reader :file_name, :temp_file, :url

  def initialize(file_name:, temp_file: nil, url: nil)
    raise "Temp file or URL should be given" if !temp_file && !url

    @file_name = file_name
    @temp_file = temp_file
    @url = url
  end
end
