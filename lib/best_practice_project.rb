require "yaml"

class BestPracticeProject
  path = "#{File.dirname(__FILE__)}/best_practice_project"

  autoload :RubocopHandler, "#{path}/rubocop_handler"

  attr_reader :rails, :rubocop_handler
  alias_method :rails?, :rails

  def self.load_tasks
    load "#{File.dirname(__FILE__)}/tasks/best_practice_project.rake"
  end

  def initialize
    @rubocop_handler = BestPracticeProject::RubocopHandler.new(best_practice_project: self) if rubocop_installed?

    if rails?
      @scss_config_path = ".scss-lint.yml" if scss_lint_installed?
      @coffee_lint_config_path = "coffeelint.json" if coffee_lint_installed?
    end

    @commands = []

    if rails?
      @commands << scss_lint_command if scss_lint_installed?
      @commands << rails_best_practices_command if rails_best_practices_installed?
    end

    @commands << proc { @rubocop_handler.execute }
  end

  def rails?
    @rails = Object.const_defined?(:Rails) if @rails == nil
    @rails
  end

  def execute
    process_status = true
    process_status = coffee_lint_execute if coffee_lint_installed?

    @commands.each do |command|
      if command.is_a?(Proc)
        puts "Executing: #{@rubocop_handler.command}"
        status = command.call unless status
      else
        puts "Executing: #{command}"
        status = system(command)
      end

      process_status = status unless status
    end

    process_status
  end

  def generate_configs
    @rubocop_handler.generate_config if rubocop_installed?
    generate_scss_config if scss_lint_installed?
    generate_coffee_lint_config if coffee_lint_installed?
  end

  def scss_lint_command
    "bundle exec scss-lint --config .scss-lint.yml app/assets/stylesheets/" if rails?
  end

  def coffee_lint_command
    "bundle exec coffeelint.rb -f coffeelint.json -r app/assets/javascripts/" if rails?
  end

  def rails_best_practices_command
    "bundle exec rails_best_practices" if rails?
  end

  def coffee_lint_execute
    require "coffeelint"

    dirs = ENV["DIRS"].split(":").map(&:strip) if ENV["DIRS"]
    dirs ||= ["app/assets/javascripts"]
    status = true

    dirs.each do |dir|
      dir = dir.strip

      puts "Running CoffeeLint on: #{dir}"
      result = Coffeelint.run_test_suite(dir)

      puts "Result: #{result}"
      status = false if result > 0
    end

    status
  end

private

  def rubocop_installed?
    require "rubocop"
    true
  rescue LoadError
    false
  end

  def scss_lint_installed?
    require "scss_lint"
    true
  rescue LoadError
    false
  end

  def coffee_lint_installed?
    require "coffeelint"
    true
  rescue LoadError
    false
  end

  def rails_best_practices_installed?
    require "rails_best_practices"
    true
  rescue LoadError
    false
  end

  def generate_coffee_lint_config
    return unless @coffee_lint_config_path
    return puts "Coffee-Lint config already exists in #{@coffee_lint_config_path}" if File.exist?(@coffee_lint_config_path)

    puts "FIXME: Generate Coffee-Lint configuration!"
  end

  def generate_scss_config
    return unless @scss_config_path
    return puts "SCSS-Lint config already exists in #{@scss_config_path}" if File.exist?(@scss_config_path)

    config = `bundle exec scss-lint --format=Config`

    File.open(@scss_config_path, "w") do |fp|
      fp.write(config)
    end

    puts "Generated SCSS-Lint config in #{@scss_config_path}"
  end
end
