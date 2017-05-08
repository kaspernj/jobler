class ApplicationJoblerController < Jobler::BaseController
  def default_url_options
    {
      host: @jobler.job.host,
      port: @jobler.job.port,
      protocol: @jobler.job.protocol
    }
  end
end
