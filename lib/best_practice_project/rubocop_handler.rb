class BestPracticeProject::RubocopHandler
  def initialize(args)
    @bpp = args.fetch(:best_practice_project)
    @actual_config_path = File.realpath("#{File.dirname(__FILE__)}/config/rubocop.yml")

    if rails?
      @config_path = Rails.root.join(".rubocop.yml").to_s
      @todo_path = Rails.root.join(".rubocop_todo.yml").to_s
    else
      @config_path = ".rubocop.yml"
      @todo_path = ".rubocop_todo.yml"
    end
  end

  def rails?
    @bpp.rails?
  end

  def command
    command = "bundle exec rubocop --display-cop-names"
    command << " --rails" if rails?
    command << " --auto-correct" if ARGV.include?("auto-correct")

    command
  end

  def generate_config
    require "fileutils"
    FileUtils.copy(@actual_config_path, @config_path)

    generate_todo_config

    puts "Generated Rubocop todo config in #{@todo_path}"
    puts "Generated Rubocop config in  #{@config_path}"
  end

  def generate_todo_config
    rubocop_command = "rubocop --display-cop-names --auto-gen-config --config=#{@config_path}"
    rubocop_command << " --rails" if @bpp.rails?

    system(rubocop_command)
  end

  def execute
    system(command)
  end
end
