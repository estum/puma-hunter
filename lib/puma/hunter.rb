require "pathname"
require "procps"
require "puma/hunter/version"
require "puma/hunter/errors"

class Puma::Hunter
  def self.from_pidfile(path, *args)
    pidfile = Pathname(path)

    if pid = pidfile.read
      new(pid.to_i, *args)
    else
      fail PIDNotFound, path
    end
  end

  def initialize(ppid, signal: "INT", max_mb: 1000, simulate: false)
    @ppid      = ppid
    @max_bytes = (max_mb * (1024 ** 2)).to_i
    @simulate  = simulate
    @signal    = signal
  end

  def call
    used_rss = Procps::Memsize.new(used_bytes / 1024)

    warn "Running in simulate mode" if simulate?
    puts "#{used_rss.inspect} with #{workers.size} workers without master (#{@ppid})."

    if used_bytes >= @max_bytes
      pid_to_kill = workers[-1][:pid]
      warn "Out of max #{Procps::Memsize.new(@max_bytes / 1024).inspect}. Sending #{@signal} to PID #{pid_to_kill}."

      unless simulate?
        Process.kill(@signal, pid_to_kill)
      end
    end
  end

  def workers
    @workers ||= Procps::PS.new("/bin/ps").select(:pid, :ppid, :rss).where(ppid: @ppid).sort("+rss").to_a
  end

  def used_bytes
    @used_bytes ||= workers.reduce { |a, e| a + e[:rss] }
  end

  def simulate?
    !!@simulate
  end
end
