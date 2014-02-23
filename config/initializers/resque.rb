Resque.logger = Logger.new('log/resque_logger.log')

redis_config = YAML.load_file(File.join(Rails.root, 'config', 'redis.yml'))[Rails.env]
Resque.redis = Redis.new(redis_config)

schedule = {}
Dir[File.join(Rails.root, 'config', 'schedule.yml')].each do |schedule_file|
  contents = YAML.load_file(schedule_file)
  schedule.merge! contents if contents
end

# set Rails Env directly. Makes Rufus Scheduler fire jobs correctly
schedule.each { |job_name, config| config.merge!({ 'rails_env' => Rails.env }) }

Resque.schedule = schedule

Resque.redis = Redis.new(redis_config)

