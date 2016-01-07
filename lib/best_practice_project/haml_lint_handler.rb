class BestPracticeProject::HamlLintHandler < BestPracticeProject::BaseHandler
  def installed?
    require "haml_lint"
    true
  rescue LoadError
    false
  end

  def generate_config
    puts "HamlLintHandler: Copying standard config"
    FileUtils.copy(bpp_config_path, config_path)
  end

  def command
    @command ||= "bundle exec haml-lint app"
  end

  def execute
    system(command)
  end

private

  def bpp_config_path
    @bpp_config_path ||= File.realpath("#{File.dirname(__FILE__)}/config/haml-lint.yml")
  end

  def config_path
    @config_path ||= Rails.root.join(".haml-lint.yml").to_s
  end
end
