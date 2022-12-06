class User < ApplicationRecord
  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 50 }

  # https://rubular.com/r/ZMFtrzsTNA8nK9
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: true
  before_save { self.email = email.downcase }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  # creates a new remember token, assigns to self.remember_token
  # saves digest to the db
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  # (note: there is also an instance method 'authenticate' provided by
  # has_secure_password for verifiying passwords)
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  class << self
    """
    Methods defined here are class methods
    there are 3 ways to define class methods: 
    http://www.railstips.org/blog/archives/2009/05/11/class-and-instance-methods-in-ruby/
    """

    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end

  end
end
