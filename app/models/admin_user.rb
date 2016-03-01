class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, 
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  def to_s
    name.presence || email
  end
end
