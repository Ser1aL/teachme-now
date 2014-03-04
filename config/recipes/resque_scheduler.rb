namespace :resque do
  namespace :scheduler do
    task :start do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} PIDFILE=#{current_path}/tmp/pids/scheduler.pid \
        BACKGROUND=yes VERBOSE=1 #{fetch(:bundle_cmd, "bundle")} exec \
        rake resque:scheduler >/dev/null 2>&1 &"
    end
  end
end
