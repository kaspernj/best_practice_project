class BestPracticeProject::ScssLintHandler < BestPracticeProject::BaseHandler
  def installed?
    return false unless rails?
    require "scss_lint"
    true
  rescue LoadError
    false
  end

  def generate_config
    return unless @scss_config_path
    return puts "SCSS-Lint config already exists in #{@scss_config_path}" if File.exist?(@scss_config_path)

    config = `bundle exec scss-lint --format=Config`

    File.open(config_path, "w") do |fp|
      fp.write(config)
    end

    puts "ScssLintHandler: Generated SCSS-Lint config in #{@scss_config_path}"
  end

  def command
    "bundle exec scss-lint --config .scss-lint.yml app/assets/stylesheets/"
  end

  def execute
    system(command)
  end

private

  def config_path
    @config_path ||= ".scss-lint.yml"
  end
end
