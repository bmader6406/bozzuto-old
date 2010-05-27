class Community < ActiveRecord::Base
  validates_presence_of :title, :subtitle, :city
end
