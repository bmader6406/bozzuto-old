require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  context "AdminUser" do
    describe "#to_s" do
      subject { AdminUser.create(name: 'Tester', email: 'test@test.com', password: 'password') }

      it "returns the user's name" do
        subject.to_s.should == 'Tester'
      end

      context "when the user does not have a name" do
        subject { AdminUser.create(email: 'test@test.com', password: 'password') }

        it "returns the user's email" do
          subject.to_s.should == 'test@test.com'
        end
      end
    end
  end
end
