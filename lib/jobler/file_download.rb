class Jobler::FileDownload
  attr_reader :file_name, :temp_file, :url

  def initialize(file_name: nil, temp_file: nil, url: nil)
    raise "Temp file or URL should be given" if !temp_file && !url
    raise "No filename given with temp-file" if temp_file && file_name.blank?

    @file_name = file_name
    @temp_file = temp_file
    @url = url
  end
end
