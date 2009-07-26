class BroadcastController < ApplicationController
  before_filter :require_user, :only => [:publish, :start, :finish]
  def require_user
    if session[:user].nil?
      redirect_to "/account/login"
      return false
    end
  end

  before_filter :find_broadcast, :only => [:show]
  def find_broadcast
    @broadcast = Broadcast.find_by_uid(params[:uid])
    if @broadcast.nil?
      redirect_to "/"
      return false
    end
  end

  def get_body(url)
    response = jtv_get(url)
    if response.is_a? Net::HTTPOK
      return response.body
    else
      return "Sorry, we're experiencing some technical difficulties right now. (code #{response.code})"
    end
  end

  def show
    if @broadcast.nil?
      render :text => "Sorry, that broadcast doesn't exist", :status => 404
    end
    
    result = if @broadcast.ended_at
      @page_title = "#{@broadcast.user.name} on Camtweet"
      if @broadcast.ended_at > 10.minutes.ago
        min = 10 - ((Time.now - @broadcast.ended_at) / 1.minute).floor
        @embed = "<p>The clip will be available #{min} #{min == 1 ? 'minute' : 'minutes'} from now</p>"
      else
        if @broadcast.clip_id.nil? or @broadcast.clip_id.zero?
          @embed = "<p>No clip of this broadcast was created.</p>"
        else
          @embed = get_body("/clip/embed/#{@broadcast.clip_id}.html?volume=50&width=340&height=285")
        end
      end
    else
      @page_title = "#{@broadcast.user.name} live on Camtweet!"
      @embed = get_body("/channel/embed/#{@broadcast.user.channel}.html?volume=50&width=340&height=285")
      @chat_embed = get_body("/channel/chat_embed/#{@broadcast.user.channel}.html?width=320&height=240")
    end
  end

  def publish
    jtv_user_get("/channel/stream_key.xml").body =~ /<stream_key>(\w+)<\/stream_key>/
    @stream_key = $1
  end

  def start
    broadcast = Broadcast.create :user => session[:user], :status => params[:status]
  
    http = Twitter::HTTPAuth.new(session[:user].screen_name, session[:user].password)
    conn = Twitter::Base.new(http)
    conn.update params[:status] + " http://camtweet.com/s/#{broadcast.uid}"

    # register callbacks
    for event in ["stream_up", "stream_down"]
      result = jtv_post("/stream/register_callback.xml", {
        :callback_url => "http://www.camtweet.com/broadcast/callback",
        :event => event,
        :channel => session[:user].channel
      })
      logger.info "DID JTV POST #{result.inspect}: #{result.body}"
    end

    render :text => broadcast.uid
  end

  def finish
    @broadcast = Broadcast.find_by_uid(params[:uid])
    @broadcast.ended_at = Time.now
    @broadcast.save
    render :text => @broadcast.uid
  end
  
  def create_clip!
    options = {
      :title => "#{@broadcast.user.name} broadcast on Camtweet #{@broadcast.ended_at.strftime('%B %d, %Y')}",
      :description => "http://www.camtweet.com/s/#{@broadcast.uid}",
      :tags => "#{@broadcast.user.screen_name} #{@broadcast.user.name} camtweet",
      :start_time => @broadcast.created_at.to_i,
      :end_time => @broadcast.ended_at.to_i
    }
    logger.info "posting to /clip/create.xml: #{options.inspect}"
    result = jtv_user_post("/clip/create.xml", options, {}, @broadcast.user)
    logger.info "result: #{result.body}"

    result.body =~ /<id>(\d+)<\/id>/
    @broadcast.clip_id = $1.to_i
    @broadcast.clip_images = Hash.new
    result.body.scan(/<image_url_(\w+)>(.*)<\/image_url_\1>/).each do |size, url|
      @broadcast.clip_images[size] = url
    end
    @broadcast.save
  end
  
  skip_before_filter :verify_authenticity_token, :only => [:callback]
  def callback
    u = User.find_by_channel(params[:channel])
    render :nothing => true and return unless u
    broadcasts = u.broadcasts.find(:all, :conditions => "ended_at is null")
    
    if params[:event] == "stream_up"
      for broadcast in broadcasts
        broadcast.created_at = Time.at(params[:server_time].to_i)
      end    
    elsif params[:event] == "stream_down"
      for @broadcast in broadcasts
        @broadcast.ended_at = Time.at(params[:server_time].to_i)
        create_clip!
      end
    end
    render :nothing => true
  end
end
