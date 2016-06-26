# Puma::Hunter

This gem provides a separated service to kill puma workers without needing to add extra thread in your master worker process. It can be simply executed with a cron, systemd timers or other scheduling service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puma-hunter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puma-hunter

## Usage

    $ puma-hunter -m 4512 /path/to/puma_pidfile.pid

Simply run when you need, it will kill the tallest worker in the cluster if sum of RSS usage is gt 4512 Mb:

### systemd

Example systemd timer:

```ini
[Unit]
Description="Puma Hunter Timer"

[Timer]
OnCalendar=*-*-* *:0/1:00
Unit=puma-hunter.service

[Install]
WantedBy=basic.target
```

service unit:

```ini
[Unit]
Description="Puma Hunter Combined"

[Service]
User=user
Environment=SIGNAL=TERM
# Add as many ExecStart lines as you need for master processes:
ExecStart=/usr/local/rvm/wrappers/ruby-2.3.0/puma-hunter -m 4512 /path/to/puma_pidfile.backend.pid
# ExecStart=/usr/local/rvm/wrappers/ruby-2.3.0/puma-hunter -m 1500 /path/to/puma_pidfile.frontend.pid
Nice=19
Type=oneshot
IOSchedulingClass=2
IOSchedulingPriority=7
SuccessExitStatus=1
Restart=no
StandardOutput=syslog
SyslogFacility=cron
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/puma-hunter.

