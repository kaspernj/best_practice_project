class BestPracticeProject::BaseHandler
  def initialize(args)
    @bpp = args.fetch(:best_practice_project)
  end

  def rails?
    @bpp.rails?
  end

  def installed?
    raise "stub!"
  end

  def generate_config
    raise "stub!"
  end

  def execute
    raise "stub!"
  end
end
