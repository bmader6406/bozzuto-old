class ConversionConfiguration < ActiveRecord::Base

  belongs_to :home_community

  validates :name,
            :home_community_id,
            presence: true
end
