require 'eventmachine'
require 'parse-cron'
require "em/cron/version"

module EM
  class Cron
    # @param cron_string [String]
    # @param time_source [Class]
    # @yield [Time] the time the block was scheduled to be called by cron. If
    #   yielding this block returns `:stop` then the schedule stops.
    # @example
    #   EM.run do
    #     EM::Cron.schedule("* * * * *") do |time|
    #       puts "hello world at time: #{time}"
    #     end
    #   end
    def self.schedule(cron_string, time_source = Time, &blk)
      cron_parser = CronParser.new(cron_string, time_source)
      next_time = cron_parser.next(time_source.now)
      EM.add_timer(next_time - time_source.now) do
        result = yield(next_time)
        schedule(cron_string, &blk) unless result == :stop
      end
    end
  end
end
