# encoding: utf-8
require 'ostruct'
module Jiralicious
  module Configuration
    VALID_OPTIONS = [:username, :password, :uri, :api_version, :auth_type]
    DEFAULT_USERNAME = nil
    DEFAULT_PASSWORD = nil
    DEFAULT_AUTH_TYPE = :basic
    DEFAULT_URI = nil
    DEFAULT_API_VERSION = "latest"

    def configure
      yield self
    end

    attr_accessor *VALID_OPTIONS

    # Reset when extended into class
    def self.extended(base)
      base.reset
    end

    def options
      VALID_OPTIONS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      self.username = DEFAULT_USERNAME
      self.password = DEFAULT_PASSWORD
      self.uri = DEFAULT_URI
      self.api_version = DEFAULT_API_VERSION
      self.auth_type = DEFAULT_AUTH_TYPE
    end

    def load_yml(yml_file)
      if File.exist?(yml_file)
        yml_cfg = OpenStruct.new(YAML.load_file(yml_file))
        yml_cfg.jira.each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      else
        reset
      end
    end
  end
end
