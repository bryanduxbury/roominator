class ApplicationController < ActionController::Base

  require 'yaml'
  protect_from_forgery

  @@service = nil
  @@worker_queue = nil

  def self.authenticate_to_gcal
    if !@@service
      auth_data = YAML::load(File.open("config/authentication.yml"))
      @@service = GCal4Ruby::Service.new
      @@service.authenticate(auth_data['email'], auth_data['password'])
    end
    @@service
  end

  protected

  def start_worker_thread
    if @@worker_queue.nil?
      @@worker_queue = []
      Thread.new(@@worker_queue) do |queue|
        while true do
          block.call queue.shift
        end
      end
    end
  end

  def enqueue_for_worker(&block)
    @@worker_queue << block
  end

end
