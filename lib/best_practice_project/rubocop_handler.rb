class BestPracticeProject::RubocopHandler
  def initialize(args)
    @bpp = args.fetch(:best_practice_project)
    @actual_config_path = File.realpath("#{File.dirname(__FILE__)}/../../config/rubocop.yml")

    if rails?
      @config_path = Rails.root.join("config", "rubocop.yml").to_s
      @todo_path = Rails.root.join("config", "rubocop_todo.yml").to_s
    else
      @config_path = "config/rubocop.yml"
      @todo_path = "config/rubocop_todo.yml"
    end
  end

  def rails?
    @bpp.rails?
  end

  def update_best_practice_path
    self.inherit_from_to = @actual_config_path
  end

  def reset_best_practice_path
    self.inherit_from_to = "$$$best_practice_project_config_path$$$"
  end

  def command
    command = "bundle exec rubocop --display-cop-names"
    command << " --rails" if rails?

    if File.exist?(@config_path)
      command << " \"--config=#{@config_path}\""
    end

    command
  end

  def generate_config
    return puts "Rubocop config already exists in #{@config_path}" if File.exist?(@config_path)

    File.open(@todo_path, "w") do |fp|
      fp.write(generate_todo_config)
    end

    puts "Generated Rubocop todo config in #{@todo_path}"

    generated_config = {}
    generated_config["inherit_from"] = "rubocop_todo.yml"

    File.open(@config_path, "w") do |fp|
      fp.write(YAML.dump(generated_config))
    end

    puts "Generated Rubocop config in  #{@config_path}"
  end

  def generate_todo_config
    if rails?
      todo_file_path = Rails.root.join(".rubocop_todo.yml").to_s
      todo_backup_file_path = Rails.root.join(".rubocop_todo_backup.yml").to_s
    else
      todo_file_path = ".rubocop_todo.yml"
      todo_backup_file_path = ".rubocop_todo_backup.yml"
    end

    if File.exist?(todo_file_path)
      File.rename(todo_file_path, todo_backup_file_path)
    end

    system("rubocop --rails --display-cop-names --auto-gen-config --config=#{@actual_config_path}")

    raise "Todo-file was not generated" unless File.exist?(todo_file_path)

    todo_config = YAML.load_file(todo_file_path)
    File.unlink(todo_file_path)
    File.rename(todo_backup_file_path, todo_file_path) if File.exist?(todo_backup_file_path)

    todo_config
  end

  def execute
    update_best_practice_path

    begin
      system(command)
    ensure
      reset_best_practice_path
    end
  end

private

  def inherit_from_to=(new_inherit_from)
    todo_config = File.read(@todo_path)
    todo_config.gsub!(/^inherit_from: (.+)$/, "inherit_from: \"#{new_inherit_from}\"")

    File.open(@todo_path, "w") do |fp|
      fp.write(todo_config)
    end
  end
end
