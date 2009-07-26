class PageController < ApplicationController
  def front
    @page_title = "Welcome to Camtweet! Share live video on Twitter."
  end
  
  def contact
    @page_title = "Welcome to Camtweet! Share live video on Twitter."
    @no_login = true
  end
end
