class HomeController < ApplicationController
  def index
    @rooms = Rooms.find(:all) # :conditions => ""
  end

end
