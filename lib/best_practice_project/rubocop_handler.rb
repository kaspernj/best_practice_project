class BestPracticeProject::RubocopHandler < BestPracticeProject::BaseHandler
  def initialize(args)
    super

    @actual_config_path = File.realpath("#{File.dirname(__FILE__)}/config/rubocop.yml")

    if rails?
      @config_path = Rails.root.join(".rubocop.yml").to_s
      @todo_path = Rails.root.join(".rubocop_todo.yml").to_s
    else
      @config_path = ".rubocop.yml"
      @todo_path = ".rubocop_todo.yml"
    end
  end

  def command
    command = "bundle exec rubocop --display-cop-names"
    command << " --rails" if rails?
    command << " --auto-correct" if ARGV.include?("auto-correct")

    command
  end

  def generate_config
    FileUtils.copy(@actual_config_path, @config_path)

    generate_todo_config

    puts "Generated Rubocop todo config in #{@todo_path}"
    puts "Generated Rubocop config in  #{@config_path}"
  end

  def generate_todo_config
    rubocop_command = "rubocop --display-cop-names --auto-gen-config --config=#{@config_path}"
    rubocop_command << " --rails" if rails?

    system(rubocop_command)
  end

  def execute
    system(command)
  end

  def installed?
    require "rubocop"
    true
  rescue LoadError
    false
  end
end
