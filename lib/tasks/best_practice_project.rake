namespace "best_practice_project" do
  task "run" do |_t, _args| # rubocop:disable Rails/RakeEnvironment
    exit BestPracticeProject.new.execute
  end

  task "run_haml_lint" do # rubocop:disable Rails/RakeEnvironment
    exit BestPracticeProject.new.haml_lint_handler.execute
  end

  task "run_rubocop" do # rubocop:disable Rails/RakeEnvironment
    exit BestPracticeProject.new.rubocop_handler.execute
  end

  task "run_scss_lint" do # rubocop:disable Rails/RakeEnvironment
    exit BestPracticeProject.new.scss_lint_handler.execute
  end

  task "run_coffee_lint" do # rubocop:disable Rails/RakeEnvironment
    exit BestPracticeProject.new.coffee_lint_handler.execute
  end

  task "run_rails_best_practices" do # rubocop:disable Rails/RakeEnvironment
    exit BestPracticeProject.new.rails_best_practices_handler.execute
  end

  task "generate_configs" do # rubocop:disable Rails/RakeEnvironment
    BestPracticeProject.new.generate_configs
  end
end
