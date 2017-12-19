class Relationship < ApplicationRecord
	# 14.3 - Follower belongs_to association to Relationship model
	belongs_to :follower, class_name: "User"
  	belongs_to :followed, class_name: "User"
  	# 14.5 - Adding Relationship model validations
  	validates :follower_id, presence: true
  	validates :followed_id, presence: true
end
