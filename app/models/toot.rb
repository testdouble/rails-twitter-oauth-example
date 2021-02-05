class Toot < ApplicationRecord
  belongs_to :user
  belongs_to :twitter_authorization

  validates_presence_of :text, :twitter_authorization_id, :user_id

  def sent_to_twitter_at_human
    return unless sent_to_twitter_at?
    sent_to_twitter_at.in_time_zone(user.time_zone).strftime("%B %e at%l:%M %p (%Z)")
  end
end
