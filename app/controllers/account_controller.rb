class AccountController < ApplicationController  
  def login
    render and return if request.get?

    if params[:screen_name]
      screen_name = params[:screen_name].strip.downcase
    else
      screen_name = nil
    end
    
    unless screen_name and (Invite.find_by_invitee_screen_name(screen_name) or User.find_by_screen_name(screen_name))
      flash[:error] = "You haven't been invited to Camtweet yet."
      render and return
    end
    
    do_login
  end
  
  def chat_login
    render and return if request.get?
    
    screen_name = params[:screen_name].strip.downcase
    password = params[:password]

    begin
      user = User.login_or_create(screen_name, password)
      session[:user] = user
      render :nothing => true, :status => 200 and return
    rescue User::TwitterVerifyException
      render :text => "Sorry, we couldn't log you into Twitter.", :status => 400 and return
    rescue User::JtvAccountException
      render :text => "Sorry, we couldn't create a Justin.tv channel for you.", :status => 400 and return
    rescue User::NoInviteException
      render :text => "You haven't been invited to Camtweet yet.", :status => 400 and return
    rescue
      render :text => "Something went wrong...", :status => 500 and return
    end
  end
  
  def login_with_invite_code
    render and return if request.get?
    ic = InviteCode.find_by_uid(params[:invite_code])
    if ic and ic.available > 0
      do_login and ic.decrement!(:available)
    elsif params[:invite_code]
      if ic
        flash[:error] = "Sorry, that invite code is all used up!"
      else
        flash[:error] = "Invalid invite code."
      end
    end
  end

  def logout
    logger.info "Logging you out"
    reset_session
    redirect_to "/"
  end
  
  protected
  
  def do_login
    screen_name = params[:screen_name].strip.downcase
    password = params[:password]

    begin
      user = User.login_or_create(screen_name, password)
      session[:user] = user
      flash[:notice] = "Welcome to Camtweet! Get ready to Tweet!"
      redirect_to "/broadcast/publish"
      return true
    rescue User::TwitterVerifyException
      flash[:error] = "Sorry, we couldn't log you into Twitter."
      render and return
    rescue User::JtvAccountException
      flash[:error] = "Sorry, we couldn't create a Justin.tv channel for you."
      render and return
    end
  end
end
