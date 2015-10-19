require "logger"
require "./controller"
require "./configuration"

module Application
  class Base
    property(arguments)
    property(environment)
    property(logger)
    getter(env)

    include Application::Controller 

    def initialize(@arguments, @environment)
      @logger = Logger.new(File.open("#{root}/log/#{env}.log", "a+"))
    end
  end
end
