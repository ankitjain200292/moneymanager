class User < ActiveRecord::Base
  #method for checking password before updating users profile
  before_update :check_password
  
  mount_uploader :profile_image, AvatarUploader
  
  has_many :financial_accounts, dependent: :destroy
  
  before_save { self.email = email.downcase }
  validates :username,  presence: true, length: { maximum: 50 },uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       length: { minimum: 6 },
                       on: :create
                  
  has_secure_password
  
  
  private
  
    def check_password
      is_ok = self.password.nil? || self.password.empty? || self.password.length >= 6

      self.errors[:password] << "Password is too short (minimum is 6 characters)" unless is_ok

      is_ok # The callback returns a Boolean value indicating success; if it fails, the save is blocked
    end

end
