class LassoAccount < ActiveRecord::Base
  belongs_to :property
  validates_presence_of :property_id, :uid, :client_id, :project_id
end
