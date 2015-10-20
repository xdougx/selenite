require "logger"
require "./controller"
require "./configuration"

module Selenite
  class Base
    property(arguments)
    property(environment)
    property(logger)

    include Selenite::Controller 

    def initialize(@arguments, @environment)
      @logger = Logger.new(File.open("#{root}/log/#{env}.log", "a+"))
    end
  end
end
