class Jobler::DownloadsController < Jobler::ApplicationController
  def show
    @job = Jobler::Job.find_by!(slug: params[:id])
    @result = @job.jobler.result

    if @result.is_a?(Jobler::FileDownload)
      if @result.url.present?
        redirect_to @result.url
      else
        send_file @result.temp_file.path, disposition: "attachment", filename: @result.file_name
      end
    else
      flash[:error] = "The result wasn't a file download"
      redirect_to :back
    end
  end
end
