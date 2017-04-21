class SaintTasks < Thor
	include Rails.application.config.dradis.thor_helper_module

  namespace "dradis:plugins:saint"

  desc "upload FILE", "upload Saint XML file"
  def upload(file_path)
    require 'config/environment'

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    unless File.exists?(file_path)
      $stderr.puts "** the file [#{file_path}] does not exist"
      exit(-1)
    end

    detect_and_set_project_scope
    importer = Dradis::Plugins::Saint::Importer.new(logger: logger)
    importer.import(file: file_path)

    logger.close
  end
end
