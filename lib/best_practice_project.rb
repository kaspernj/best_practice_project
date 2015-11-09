class BestPracticeProject
  attr_reader :rails
  alias_method :rails?, :rails

  def self.load_tasks
    load "#{File.dirname(__FILE__)}/tasks/best_practice_project.rake"
  end

  def initialize
    @rubocop_actual_config_path = File.realpath("#{File.dirname(__FILE__)}/../config/rubocop.yml")

    if Object.const_defined?(:Rails)
      @rails = true

      @rubocop_config_path = Rails.root.join("config", "rubocop.yml").to_s
      @scss_config_path = Rails.root.join("config", "scss-lint.yml").to_s
      @coffee_lint_config_path = Rails.root.join("config", "coffeelint.json").to_s
    else
      @rails = false

      @rubocop_config_path = "config/rubocop.yml"
    end

    @commands = []

    if rails?
      @commands << scss_lint_command
      @commands << coffee_lint_command
      @commands << rails_best_practices_command
    end

    @commands << rubocop_command
  end

  def execute
    process_status = true

    @commands.each do |command|
      puts "Executing: #{command}"

      status = system(command)
      process_status = status unless status
    end

    process_status
  end

  def generate_configs
    generate_rubocop_config
    generate_scss_config
    generate_coffee_lint_config
  end

  def rubocop_command
    command = "bundle exec rubocop --display-cop-names"
    command << " --rails" if rails?

    if File.exist?(@rubocop_config_path)
      command << " \"--config=#{@rubocop_config_path}\""
    end

    command
  end

  def scss_lint_command
    "bundle exec scss-lint --config config/scss-lint.yml app/assets/stylesheets/" if rails?
  end

  def coffee_lint_command
    "bundle exec coffeelint.rb -f config/coffeelint.json -r app/assets/javascripts/" if rails?
  end

  def rails_best_practices_command
    "bundle exec rails_best_practices" if rails?
  end

private

  def generate_coffee_lint_config
    return puts "Coffee-Lint config already exists in #{@coffee_lint_config_path}" if File.exist?(@coffee_lint_config_path)

    puts "FIXME: Generate Coffee-Lint configuration!"
  end

  def generate_scss_config
    return puts "SCSS-Lint config already exists in #{@scss_config_path}" if File.exist?(@scss_config_path)

    config = `bundle exec scss-lint --format=Config`

    File.open(@scss_config_path, "w") do |fp|
      fp.write(config)
    end

    puts "Generated SCSS-Lint config in #{@scss_config_path}"
  end

  def generate_rubocop_config
    return puts "Rubocop config already exists in #{@rubocop_config_path}" if File.exist?(@rubocop_config_path)

    project_todo_path = Rails.root.join("config", "rubocop_todo.yml").to_s

    generated_todo_config = {}
    generated_todo_config["inherit_from"] = @rubocop_actual_config_path
    generated_todo_config.merge!(generate_rubocop_todo_config)

    File.open(project_todo_path, "w") do |fp|
      fp.write(YAML.dump(generated_todo_config))
    end

    puts "Generated Rubocop todo config in #{project_todo_path}"

    generated_config = {}
    generated_config["inherit_from"] = "rubocop_todo.yml"

    File.open(@rubocop_config_path, "w") do |fp|
      fp.write(YAML.dump(generated_config))
    end

    puts "Generated Rubocop config in  #{@rubocop_config_path}"
  end

  def generate_rubocop_todo_config
    todo_file_path = Rails.root.join(".rubocop_todo.yml").to_s
    todo_backup_file_path = Rails.root.join(".rubocop_todo_backup.yml").to_s

    if File.exist?(todo_file_path)
      File.rename(todo_file_path, todo_backup_file_path)
    end

    system("rubocop --rails --display-cop-names --auto-gen-config --config=#{@rubocop_actual_config_path}")

    raise "Todo-file was not generated" unless File.exist?(todo_file_path)

    todo_config = YAML.load_file(todo_file_path)
    File.unlink(todo_file_path)
    File.rename(todo_backup_file_path, todo_file_path) if File.exist?(todo_backup_file_path)

    todo_config
  end
end
