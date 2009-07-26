class ChatController < ApplicationController
  def tweet
    broadcast = Broadcast.find_by_uid(params[:uid])
    http = Twitter::HTTPAuth.new(session[:user].screen_name, session[:user].password)
    conn = Twitter::Base.new(http)
    update = conn.update "@#{broadcast.user.screen_name} " + params[:status] + " http://camtweet.com/s/#{broadcast.uid}"
    # fields on update: ["favorited", "created_at", "truncated", "text", "id", "in_reply_to_user_id", "user", "in_reply_to_screen_name", "source", "in_reply_to_status_id"]

    set_content_type 'application/json'
    render :text => {
      "text" => update["text"], 
      "source" => update["source"], 
      "from_user" => session[:user].screen_name,
      "profile_image_url" => session[:user].profile_image_url,
      "created_at" => update["created_at"],
      "id" => update["id"]
    }.to_json
  end
  
  def twitter
    @broadcast = Broadcast.find_by_uid(params[:uid])
    render :partial => "twitter"
  end
  
  private
  def set_content_type content_type
    headers["Content-Type"] = content_type
  end
end
