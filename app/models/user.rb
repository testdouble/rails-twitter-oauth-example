class User < ApplicationRecord
  has_secure_password
  has_many :toots
  has_many :twitter_authorizations
end
