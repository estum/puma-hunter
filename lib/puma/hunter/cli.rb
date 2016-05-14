require 'puma/hunter'
require 'optparse'
require 'methadone'

class Puma::Hunter
  class CLI
    include Methadone::Main
    include Methadone::CLILogging

    main do |path|
      hunter = Puma::Hunter.from_pidfile(path,
        :max_mb   => options['max-rss'].to_f,
        :signal   => options['signal'],
        :simulate => options['simulate']
      )
      hunter.call
    end

    version VERSION

    description "Finds fingerings of the requested chord."


    ##
    # Arguments
    #
    arg :pidfile, "Puma's master worker PIDFile."


    ##
    # Options
    #
    options['max-rss']  = ENV.fetch('PUMA_MAX_RSS_MB') { 1000 }
    options['signal']   = ENV.fetch('SIGNAL') { 'INT' }
    options['simulate'] = ENV['SIMULATE'] == '1'

    on "-m N",      "--max-rss N",      Integer, "Max total memory used by workers in Mb."
    on "-s",        "--signal SIGNAL",           "Signal to send to kill worker."
    on "-S",        "--[no-]simulate",           "Only simulate."

    use_log_level_option
  end
end