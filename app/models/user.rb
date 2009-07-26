class User < ActiveRecord::Base
  has_many :broadcasts, :dependent => :destroy

  self.extend(JtvClient)
  
  def self.login_or_create(screen_name, password)
    http = Twitter::HTTPAuth.new(screen_name, password)
    conn = Twitter::Base.new(http)
    begin
      conn.verify_credentials
    rescue => e
      raise TwitterVerifyException
    end
    user_data = conn.user(screen_name)
    
    user = User.find_by_screen_name_and_password(screen_name, password)
    unless user
      # TODO: handle case where user with screen name and diff password exists
      user = User.new :screen_name => screen_name, :password => password
      channel_name = "camtweet#{rand 10000000}"
      channel_password = Digest::SHA1.hexdigest rand(100000000).to_s
      result = jtv_post "/channel/create.xml", {
        :login => channel_name, 
        :password => channel_password,
        :birthday => "1911-01-01",
        :email => "testing@justin.tv",
        :category => "social",
        :subcategory => "social",
        :title => "#{user_data.name} on Camtweet",
        :anonymous_chatters_allowed => "true"
      }
      unless result.is_a?(Net::HTTPOK)
        logger.info "Error creating Justin.tv account: #{result.class.name} #{result.body}"
        raise JtvAccountException
      end
      if result.body =~ /<access_token>(\w+)<\/access_token>/
        user.access_token = $1
      end
      if result.body =~ /<access_token_secret>(\w+)<\/access_token_secret>/
        user.access_token_secret = $1
      end
      user.channel = channel_name
      user.channel_password = channel_password
    end
    user.update_attributes(
      :profile_image_url => user_data.profile_image_url,
      :twitter_id => user_data.id.to_i,
      :name => user_data.name
    )
    return user
  end
  
  class TwitterVerifyException < Exception
  end
  
  class JtvAccountException < Exception
  end  
end
