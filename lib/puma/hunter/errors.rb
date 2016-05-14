class Puma::Hunter
  class PIDNotFound < RuntimeError
    def initialize(path)
      super("PID not found when reading pidfile from path '#{path}'.")
    end
  end
end