require "jobler/engine"

module Jobler
  path = "#{File.dirname(__FILE__)}/jobler"

  autoload :BaseJobler, "#{path}/base_jobler"
  autoload :FileDownload, "#{path}/file_download"
  autoload :JobScheduler, "#{path}/job_scheduler"
  autoload :JobRunner, "#{path}/job_runner"
  autoload :TemplateRenderer, "#{path}/template_renderer"
end
