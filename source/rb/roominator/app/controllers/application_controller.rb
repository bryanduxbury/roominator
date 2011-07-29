require 'yaml'

class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def authenticate_to_gcal
    unless @service
      auth_data = YAML::load(File.open("config/authentication.yml"))
      @service = GCal4Ruby::Service.new
      @service.authenticate(auth_data['email'], auth_data['password'])
    end
  end

end
