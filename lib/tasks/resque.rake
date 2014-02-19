require 'resque/tasks'
task 'resque:setup' => :environment

Rake::Task['resque:work'].clear

# This is overwritten default Resque:work rake task. Default one fails to daemonize correctly
desc 'Start a Resque worker'
task 'resque:work' => [ :preload, :setup ] do
  require 'resque'

  queues = (ENV['QUEUES'] || ENV['QUEUE']).to_s.split(',')

  begin
    worker = Resque::Worker.new(*queues)
    if ENV['LOGGING'] || ENV['VERBOSE']
      worker.verbose = ENV['LOGGING'] || ENV['VERBOSE']
    end
    if ENV['VVERBOSE']
      worker.very_verbose = ENV['VVERBOSE']
    end
    worker.term_timeout = ENV['RESQUE_TERM_TIMEOUT'] || 4.0
    worker.term_child = ENV['TERM_CHILD']
    worker.run_at_exit_hooks = ENV['RUN_AT_EXIT_HOOKS']
  rescue Resque::NoQueueError
    abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
  end

  if ENV['BACKGROUND']
    unless Process.respond_to?('daemon')
      abort "env var BACKGROUND is set, which requires ruby >= 1.9"
    end
    Process.daemon(true, false)
  end

  if ENV['PIDFILE']
    File.open(ENV['PIDFILE'], 'w') { |f| f << worker.pid }
  end

  worker.log "Starting worker #{worker}"

  worker.work(ENV['INTERVAL'] || 5) # interval, will block
end