require 'test_helper'

class LassoAccountTest < ActiveSupport::TestCase
  context 'LassoAccount' do
    should belong_to(:property)

    should validate_presence_of(:property_id)
    should validate_presence_of(:uid)
    should validate_presence_of(:client_id)
    should validate_presence_of(:project_id)

    describe "#to_s" do
      subject { LassoAccount.make(uid: 'KAPOW') }

      it "returns a string including the account UID" do
        subject.to_s.should == 'Lasso Account KAPOW'
      end
    end
  end
end
