class TestRenderJobler < Jobler::BaseJobler
  def execute!
    create_result!(
      name: "render",
      content: render(:show)
    )
  end

  def result
    Jobler::FileDownload.new(
      file_name: "some-file.html",
      temp_file: temp_file_for_result(name: "render")
    )
  end
end
