require 'bcrypt'

class User < ActiveRecord::Base
  has_many :jobs

  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validates :name, :presence => true, :length => {:minimum => 4}

  # Helps encrypt new password
  def self.encrypt_password(pass)
    BCrypt::Password.create(pass).to_s
  end

  # Helps compare a supplied password
  def does_password_match?(supplied_password)
    BCrypt::Password.new(self.password) == supplied_password
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

end