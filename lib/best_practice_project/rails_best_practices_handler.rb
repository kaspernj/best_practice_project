class BestPracticeProject::RailsBestPracticesHandler < BestPracticeProject::BaseHandler
  def command
    "bundle exec rails_best_practices"
  end

  def generate_config
    system("bundle exec rails_best_practices -g")
  end

  def execute
    system(command)
  end

  def installed?
    return false unless rails?

    require "rails_best_practices"
    true
  rescue LoadError
    false
  end
end
