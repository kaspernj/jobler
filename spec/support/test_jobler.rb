class TestJobler < Jobler::BaseJobler
  # This method will be executed in the background
  def execute!
    my_temp_file = Tempfile.new("jobler_test")

    create_result!(name: "my-file", temp_file: my_temp_file)
  end

  # This method will be called from the web when the execute is completed and successful
  def result
    result = job.results.find_by!(name: "my-file")

    if result.file.attached?
      Jobler::FileDownload.new(
        url: url_for_result(name: "my-file")
      )
    else
      Jobler::FileDownload.new(
        file_name: "some-file.zip",
        temp_file: temp_file_for_result(name: "my-file")
      )
    end
  end
end
