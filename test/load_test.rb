require 'redis'

RUN_TIME = 10
WORKER_COUNT = 100

def make_connection
  Redis.new(port: 10000)
end

def spin(worker_num)
  start_time = Time.now
  redis = make_connection
  until Time.now - start_time > RUN_TIME
    redis.set("worker:#{worker_num}", Time.now.to_s)
    sleep rand * 0.01
    redis.get("worker:#{worker_num}")
  end

  puts "Finished worker #{worker_num.to_s.rjust(3, '0')} at #{redis.get("worker:#{worker_num}")}"
end

def main
  puts "Firing up #{WORKER_COUNT} workers"
  puts "Running for #{RUN_TIME} seconds"

  workers = (1..WORKER_COUNT).map do |worker_num|
    Thread.new { spin(worker_num) }
  end

  workers.each(&:join)

  puts "All workers done"
end

main if $PROGRAM_NAME == __FILE__
