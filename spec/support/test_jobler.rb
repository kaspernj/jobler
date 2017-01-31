class TestJobler < Jobler::BaseJobler
  # This method will be executed in the background
  def execute!
    my_temp_file = Tempfile.new

    create_result!(name: "my-file", temp_file: my_temp_file)
  end

  # This method will be called from the web when the execute is completed and successful
  def result
    Jobler::FileDownload.new(
      file_name: "some-file.zip",
      temp_file: temp_file_for_result(name: "my-file")
    )
  end
end
