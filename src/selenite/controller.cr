module Selenite
  module Controller
    # available environments
    ENVS = %w(test development production staging)

    # verify if env is production
    def production?
      @arguments.includes?("production")
    end

    # verify if is a call to stop the application
    def stop?
      @arguments.includes?("stop")
    end

    # verify if is a server to run
    def server?
      @arguments.includes?("server")
    end

    # return if running
    def running?
      return check_process if File.exists?(pid_file)
      false
    end

    def kind
      server? ? "server" : "application"
    end

    # verify if it has an process already running
    def check_process
      begin
        id = `cat #{pid_file}`.chomp
        Process.getpgid(id.to_i)
        true
      rescue
        File.delete(pid_file)
        false
      end
    end

    # get the current env
    def env
      current = "development"
      ENVS.each do |env|
        current = env if @arguments.includes?(env)
      end
      current
    end
    
    # initiate the application and run a procces server or application
    def start(&block : Application::Base)
      return stop if stop?      
      
      if running?
        raise "already running"
      else
        server? ? start_server(&block) : start_application(&block)
      end
    end

    # stop the process started
    def stop
      begin
        pid = `cat #{pid_file}`.chomp
        Process.kill(Signal::TERM, pid.to_i)
        File.delete(pid_file)
        @logger.info("Stopped #{kind} on env #{env} with pid #{pid}", kind)
        puts "Stopped #{kind} on env #{env} with pid #{pid}"
      rescue e
        @logger.info("This application is not running", kind)
        puts "This application is not running"
      end
    end

    # get the full pid file
    def pid_file
      "#{root}/tmp/pids/#{env}.#{kind}.pid"
    end

    # the the full path of the application root
    def root
      @environment["PWD"]
    end

    def start_application(&block)
      Process.fork do |process|
        init(process)
        yield(self)
      end
    end

    def start_server(&block)
      Process.fork do |process| 
        init(process)
        yield(self)
      end
    end

    def init(process)
      @logger.info("Starting Process with PID #{process.pid}", kind)
      build_pid(process.pid)
    end

    def build_pid(pid)
      File.open(pid_file, "a+") do |file|
        file << pid
      end
    end
  end
end