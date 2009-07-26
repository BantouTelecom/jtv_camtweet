module JtvClient
  def jtv_get(path)
    get_conn(false).get("#{API_PATH}#{path}")
  end

  def jtv_post(path, post_params, headers={})
    get_conn(false).post("#{API_PATH}#{path}", post_params, headers)
  end

  def jtv_user_get(path, user=nil)
    get_conn(true, user).get("#{API_PATH}#{path}")
  end  

  def jtv_user_post(path, post_params, headers={}, user=nil)
    get_conn(true, user).post("#{API_PATH}#{path}", post_params, headers)
  end  

  def get_conn(use_oauth_tokens=true, user=nil)
    if use_oauth_tokens
      user ||= session[:user]
      OAuth::AccessToken.new JTV_CONSUMER, user.access_token, user.access_token_secret
    else
      OAuth::AccessToken.new JTV_CONSUMER
    end
  end
end