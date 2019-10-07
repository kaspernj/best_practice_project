namespace "best_practice_project" do
  task "run" do |_t, _args|
    exit BestPracticeProject.new.execute
  end

  task "run_haml_lint" do
    exit BestPracticeProject.new.haml_lint_handler.execute
  end

  task "run_rubocop" do
    exit BestPracticeProject.new.rubocop_handler.execute
  end

  task "run_scss_lint" do
    exit BestPracticeProject.new.scss_lint_handler.execute
  end

  task "run_coffee_lint" do
    exit BestPracticeProject.new.coffee_lint_handler.execute
  end

  task "run_rails_best_practices" do
    exit BestPracticeProject.new.rails_best_practices_handler.execute
  end

  task "generate_configs" do
    BestPracticeProject.new.generate_configs
  end
end
