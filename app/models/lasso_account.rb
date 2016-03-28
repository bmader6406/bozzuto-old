class LassoAccount < ActiveRecord::Base

  belongs_to :home_community

  validates :home_community_id,
            :uid,
            :client_id,
            :project_id,
            presence: true

  def to_s
    "Lasso Account #{uid}"
  end
end
