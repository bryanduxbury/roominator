class HomeController < ApplicationController
  
  def index
    @rooms = Room.all
  end

end
