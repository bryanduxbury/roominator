class ApplicationController < ActionController::Base

  require 'yaml'
  protect_from_forgery

  private

  def authenticate_to_gcal
    if !@service
      auth_data = YAML::load(File.open("config/authentication.yml"))
      begin
        @service = GCal4Ruby::Service.new(auth_data[:email], auth_data[:password])
      rescue AuthenticationFailedError
        @service = nil #this oughta be nicer TODO
      end
    end
  end

end
