require "yaml"
require "fileutils"
require "auto_autoloader"

class BestPracticeProject
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  attr_reader :rubocop_handler, :haml_lint_handler, :scss_lint_handler, :coffee_lint_handler, :rails_best_practices_handler

  def self.load_tasks
    load "#{File.dirname(__FILE__)}/tasks/best_practice_project.rake"
  end

  def initialize
    @rubocop_handler = BestPracticeProject::RubocopHandler.new(best_practice_project: self)
    @haml_lint_handler = BestPracticeProject::HamlLintHandler.new(best_practice_project: self)
    @scss_lint_handler = BestPracticeProject::ScssLintHandler.new(best_practice_project: self)
    @coffee_lint_handler = BestPracticeProject::CoffeeLintHandler.new(best_practice_project: self)
    @rails_best_practices_handler = BestPracticeProject::RailsBestPracticesHandler.new(best_practice_project: self)

    @handlers = [
      @rubocop_handler,
      @haml_lint_handler,
      @scss_lint_handler,
      @coffee_lint_handler,
      @rails_best_practices_handler
    ]
  end

  def rails?
    @rails = Object.const_defined?(:Rails) if @rails == nil
    @rails
  end

  def execute
    process_status = true

    @handlers.select(&:installed?).each do |handler|
      handler_result = handler.execute
      process_status = false unless handler_result
    end

    process_status
  end

  def generate_configs
    puts "Handlers: #{@handlers.select(&:installed?).map(&:class).map(&:name)}"

    @handlers.select(&:installed?).map(&:generate_config)
  end

private

  def commands
    unless @commands
      @commands = []

      if rails?
        @commands << @scss_lint_handler.command if @scss_lint_handler.installed?
        @commands << @rails_best_practices_handler.command if @rails_best_practices_handler.installed?
      end

      @commands << proc { @rubocop_handler.execute }
    end

    @commands
  end
end
