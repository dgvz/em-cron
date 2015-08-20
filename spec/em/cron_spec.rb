require 'spec_helper'

describe EM::Cron do
  describe '#schedule' do
    it 'runs the task' do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)
      allow_any_instance_of(CronParser).to receive(:next).with(now).and_return(now)
      EM.run do
        EM.add_timer(1) { raise "timed out" }
        EM::Cron.schedule("* * * * *") do
          EM.stop
        end
      end
    end
  end
end
