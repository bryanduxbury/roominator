class HomeController < ApplicationController
  def index
    @rooms = Room.find(:all) # :conditions => ""
  end

end
