class TwitterAuthorization < ApplicationRecord
  belongs_to :user
  has_many :toots
end
