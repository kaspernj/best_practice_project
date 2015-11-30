class BestPracticeProject::RubocopHandler
  def initialize(args)
    @bpp = args.fetch(:best_practice_project)
    @actual_config_path = File.realpath("#{File.dirname(__FILE__)}/config/rubocop.yml")

    if rails?
      @config_path = Rails.root.join("config", "best_project_practice_rubocop.yml").to_s
      @todo_path = Rails.root.join("config", "best_project_practice_rubocop_todo.yml").to_s
      @default_path = Rails.root.join(".rubocop.yml")
      @default_todo_path = Rails.root.join(".rubocop_todo.yml")
    else
      @config_path = "config/best_project_practice_rubocop.yml"
      @todo_path = "config/best_project_practice_rubocop_todo.yml"
      @default_path = ".rubocop.yml"
      @default_todo_path = ".rubocop_todo.yml"
    end
  end

  def rails?
    @bpp.rails?
  end

  def remove_best_practice_path
    self.inherit_from_to = nil
  end

  def update_best_practice_path
    self.inherit_from_to = @actual_config_path
  end

  def reset_best_practice_path
    self.inherit_from_to = "$$$best_practice_project_config_path$$$"
  end

  # Make default ".rubocop.yml" and ".rubocop_todo" to support Sublime Text plugins and likewise
  def update_default_configs
    remove_best_practice_path
    File.symlink(@todo_path, @default_todo_path)
    # FileUtils.cp(@todo_path, @default_todo_path)

    # Make default ".rubocop.yml" and ".rubocop_todo" to support Sublime Text plugins and likewise
    generated_config = {"inherit_from" => [@actual_config_path, ".rubocop_todo.yml"]}
    File.open(@default_path, "w") do |fp|
      fp.write(YAML.dump(generated_config))
    end
  end

  def command
    command = "bundle exec rubocop --display-cop-names"
    command << " --rails" if rails?
    command << " \"--config=#{@config_path}\"" if File.exist?(@config_path)
    command << " --auto-correct" if ARGV.include?("auto-correct")

    command
  end

  def generate_config
    return puts "Rubocop config already exists in #{@config_path}" if File.exist?(@config_path)

    File.open(@todo_path, "w") do |fp|
      fp.write(generate_todo_config)
    end

    puts "Generated Rubocop todo config in #{@todo_path}"

    generated_config = {}
    generated_config["inherit_from"] = "best_project_practice_rubocop_todo.yml"

    File.open(@config_path, "w") do |fp|
      fp.write(YAML.dump(generated_config))
    end

    update_default_configs

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

    rubocop_command = "rubocop --display-cop-names --auto-gen-config --config=#{@actual_config_path}"
    rubocop_command << " --rails" if @bpp.rails?

    system(rubocop_command)

    raise "Todo-file was not generated" unless File.exist?(todo_file_path)

    todo_config = File.read(todo_file_path)
    File.unlink(todo_file_path)
    File.rename(todo_backup_file_path, todo_file_path) if File.exist?(todo_backup_file_path)

    todo_config
  end

  def execute
    update_best_practice_path

    begin
      system(command)
    ensure
      remove_best_practice_path
    end
  end

private

  def inherit_from_to=(new_inherit_from)
    todo_config = File.read(@todo_path)

    if new_inherit_from
      replace_with = "inherit_from: \"#{new_inherit_from}\""
    else
      replace_with = ""
    end

    if todo_config.include?("inherit_from:")
      replace_what = /^inherit_from: (.+)$/
    elsif todo_config.start_with?("---\n")
      replace_what = /\A---\n/
      replace_with.prepend("---\n")
      replace_with << "\n\n" if replace_with.length > 0
    else
      replace_what = /\A/
      replace_with << "\n\n" if replace_with.length > 0
    end

    todo_config.gsub!(replace_what, replace_with)

    raise "Couldn't insert dynamic config" unless todo_config.include?(replace_with)

    File.open(@todo_path, "w") do |fp|
      fp.write(todo_config)
    end
  end
end
