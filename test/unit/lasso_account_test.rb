require 'test_helper'

class LassoAccountTest < ActiveSupport::TestCase
  context 'LassoAccount' do
    should_belong_to :property
    should_validate_presence_of :property_id, :uid, :client_id, :project_id
  end
end
