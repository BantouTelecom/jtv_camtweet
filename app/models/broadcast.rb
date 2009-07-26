require 'digest/sha1'

class Broadcast < ActiveRecord::Base
  belongs_to :user
  serialize :clip_images, Hash
  
  def image_url(size)
    if live? or clip_images.nil?
      "http://static-cdn.justin.tv/previews/live_user_#{user.channel}-125x94.jpg"
    else
      clip_images[size]
    end
  end
  
  def live?
    ended_at.nil?
  end
  
  before_create :set_uid
  def set_uid
    self.uid = Digest::SHA1.hexdigest(rand.to_s)[0..6]
  end
end
