require 'eventmachine'
require 'parse-cron'
require "em/cron/version"

module EM
  class Cron
    # @param cron_string [String]
    # @yield [Time] the time the block was scheduled to be called by cron
    # @example
    #   EM.run do
    #     EM::Cron.schedule("* * * * *") do |time|
    #       puts "hello world at time: #{time}"
    #     end
    #   end
    def self.schedule(cron_string, &blk)
      cron_parser = CronParser.new(cron_string)
      next_time = cron_parser.next(Time.now)
      EM.add_timer(next_time - Time.now) do
        result = yield(next_time)
        schedule(cron_string, &blk) unless result == :stop
      end
    end
  end
end
