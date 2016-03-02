class County < ActiveRecord::Base

  belongs_to :state

  has_and_belongs_to_many :cities

  has_many :apartment_communities
  has_many :home_communities

  validates :name,
            presence:   true,
            uniqueness: {
              scope: :state_id
            }

  validates :state,
            presence: true

  scope :ordered_by_name, -> { order(name: :asc) }

  def to_s
    "#{name}, #{state.code}"
  end

  def to_label
    to_s
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
