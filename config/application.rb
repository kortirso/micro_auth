# frozen_string_literal: true

class Application
  def self.call(env)
    [200, {}, ['MicroAuth']]
  end

  def self.root
    File.expand_path('..', __dir__)
  end

  def self.environment
    ENV['RACK_ENV'].to_sym
  end
end
