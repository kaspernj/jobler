module Jobler
  path = "#{File.dirname(__FILE__)}/jobler"

  autoload :BaseController, "#{path}/base_controller"
  autoload :BaseJobler, "#{path}/base_jobler"
  autoload :FileDownload, "#{path}/file_download"
  autoload :JobScheduler, "#{path}/job_scheduler"
  autoload :JobRunner, "#{path}/job_runner"
  autoload :Message, "#{path}/message"
  autoload :PageRender, "#{path}/page_render"
  autoload :RedirectTo, "#{path}/redirect_to"
end

require "jobler/engine"
