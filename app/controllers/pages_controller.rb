class PagesController < ApplicationController
  layout "presentation", only: [:home]
  
  def home
  end
end
