class BestPracticeProject::CoffeeLintHandler < BestPracticeProject::BaseHandler
  def command
    "bundle exec coffeelint.rb -f coffeelint.json -r app/assets/javascripts/" if rails?
  end

  def execute
    require "coffeelint"

    dirs = ENV["DIRS"].split(":").map(&:strip) if ENV["DIRS"]
    dirs ||= ["app/assets/javascripts"]
    status = true

    dirs.each do |dir|
      dir = dir.strip

      puts "Running CoffeeLint on: #{dir}"
      result = Coffeelint.run_test_suite(dir)

      puts "Result: #{result}"
      status = false if result.positive?
    end

    status
  end

  def installed?
    require "coffeelint"
    true
  rescue LoadError
    false
  end

  def generate_config
    return unless @coffee_lint_config_path
    return puts "Coffee-Lint config already exists in #{@coffee_lint_config_path}" if File.exist?(@coffee_lint_config_path)

    puts "CoffeeLintHandler: FIXME: Generate Coffee-Lint configuration!"
  end

private

  def config_path
    @config_path ||= "coffeelint.json"
  end
end
