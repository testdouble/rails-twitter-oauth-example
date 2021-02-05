class GathersToots
  TootsSummary = Struct.new(:draft, :ready, :sent, keyword_init: true)
  def call(user:)
    unsent_toots = Toot.where(user: user, sent_to_twitter_at: nil).group_by(&:draft)
    sent_toots = Toot.where(user: user).where("sent_to_twitter_at is not null")
      .order("sent_to_twitter_at desc").limit(30)

    TootsSummary.new(
      draft: unsent_toots[true] || [],
      ready: unsent_toots[false] || [],
      sent: sent_toots
    )
  end
end
