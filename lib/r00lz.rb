# frozen_string_literal: true
require 'r00lz/version'

module R00lz
  class App
    def call(env)
      kl, act = cont_and_act(env)
      text = kl.new(env).send(act)

      [ 200,
        { 'Content-Type' => 'text/html'},
        [text]
      ]
    end

    def cont_and_act(env)
      _, con, act, after = env["PATH_INFO"].split('/', 4)
      con = con.capitalize + "Controller"
      # Using the controller class is defined as a constant
      # therfore we can just grab it out of the object and initalise it later
      [Object.const_get(con), act]
    end
  end

  #used to conver class names to snake case to require files for autorequire
  def self.to_underscore(s)
    s.gsub(
      /([A-Z]+)([A-Z][a-z])/,
      '\1_\2').gsub(
      /([a-z\d])([A-Z])/,
      '\1_\2').downcase
  end

  # used for auto require
  class Object
    def self.const_missing(c)
      require R00lz.to_underscore (c.to_s)
      Object.const_get(c)
    end
  end


  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end
  end
end
