class InviteController < ApplicationController  
  # show invites
  def index
    @invites = Invite.find_all_by_inviter_screen_name session[:user].screen_name
  end
  
  # invite a user to camtweet
  def invite
    if session[:user].invites <= 0
      flash[:error] = "You have no invites remaining. We'll give you some more soon."
    elsif Invite.find_by_invitee_screen_name params[:screen_name]
      flash[:error] = "#{params[:screen_name]} has already been invited to Camtweet. Invite someone else!"
    else
      i = Invite.create :invitee_screen_name => params[:screen_name], :inviter_screen_name => session[:user].screen_name
    
      session[:user].invites -= 1
      session[:user].save
    
      status = "@#{params[:screen_name]} #{params[:message]} #camtweet_invite http://camtweet.com/login"
      http = Twitter::HTTPAuth.new(session[:user].screen_name, session[:user].password)
      conn = Twitter::Base.new(http)
      conn.update status
    
      flash[:notice] = "You have invited #{params[:screen_name]} to Camtweet"
    end
    redirect_to "/invite/index"
  rescue Twitter::InformTwitter
    flash[:error] = "Sorry, something went wrong sending that invitation...try again?"
    redirect_to "/invite/index"
  end
end