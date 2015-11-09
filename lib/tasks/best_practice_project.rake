namespace "best_practice_project" do
  task "run" do
    BestPracticeProject.new.execute
  end

  task "run_rubocop" do
    best_practice_project = BestPracticeProject.new

    puts "Executing: #{best_practice_project.rubocop_command}"
    system(best_practice_project.rubocop_command)
  end

  task "run_scss_lint" do
    best_practice_project = BestPracticeProject.new

    puts "Executing: #{best_practice_project.scss_lint_command}"
    system(best_practice_project.scss_lint_command)
  end

  task "run_coffee_lint" do
    best_practice_project = BestPracticeProject.new

    puts "Executing: #{best_practice_project.coffee_lint_command}"
    system(best_practice_project.coffee_lint_command)
  end

  task "run_rails_best_practices" do
    best_practice_project = BestPracticeProject.new

    puts "Executing: #{best_practice_project.rails_best_practices_command}"
    system(best_practice_project.rails_best_practices_command)
  end

  task "generate_configs" do
    BestPracticeProject.new.generate_configs
  end
end
