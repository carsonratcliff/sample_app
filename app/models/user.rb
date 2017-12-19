class User < ApplicationRecord
    # 13.11 - A user has many microposts
    has_many :microposts, dependent: :destroy
	# 14.2 - Adding active relationships has_many association
    has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
    # 14.12 - user.followers using passive relationships
    has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
    # 14.8 - Adding the User model following association
    has_many :following, through: :active_relationships, source: :followed
    # 14.12 - Implementing user.followers using passive relationships
    has_many :followers, through: :passive_relationships, source: :follower
    # 9.3, 11.3 - added account activation
	attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_email
    before_create :create_activation_digest
	validates(:name, presence: true, length: { maximum: 26 })
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates(:email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false })
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
		                                              BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token.
    def User.new_token
    	SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        # 11.26 - Generalized authenticated? method, (encompasses remember token and other tokens)
        digest = send("#{attribute}_digest")
    	# 9.19 simulates if-else statement
    	return false if digest.nil?
    	# (else)
    	BCrypt::Password.new(digest).is_password?(token)
    end

    # Forgets a user.
    def forget
    	update_attribute(:remember_digest, nil)
    end

    # 11.35 - Adding user activation methods
    # Activates an account.
    def activate
        update_attribute(:activated,    true)
        update_attribute(:activated_at, Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    # 12.6 - Adding password reset methods
    # Sets the password reset attributes.
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # 12.17 - Returns true if a password reset has expired.
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # 13.46 - Preliminary micropost statud feed
    # Defines a proto-feed.
    # See "Following users" for the full implementation.
    def feed
        #microposts
        #Micropost.where("user_id = ?", id)
        
        # 14.44
        #Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
        
        # 14.46 - Key-value pairs in the feed's where method
        #Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
        #            following_ids: following_ids, user_id: id)
        
        # 14.47 - Final implementation
        following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
    end

    # 14.10 - Utility methods for following
    # Follows a user.
    def follow(other_user)
        #following << other_user
        # 14.44 - Initial working feed
        active_relationships.create(followed_id: other_user.id)
    end

    # Unfollows a user.
    def unfollow(other_user)
        following.delete(other_user)
    end

    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end

    # 11.3 - Adding account activation
    private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end


