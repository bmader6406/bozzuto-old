require 'test_helper'

class AdSourceTest < ActiveSupport::TestCase
  context "An AdSource" do
    subject { AdSource.make }

    describe "validating" do
      should validate_presence_of(:domain_name)
      should validate_presence_of(:value)
      should validate_uniqueness_of(:domain_name)

      context "domain includes protocol" do
        before do
          subject.domain_name = 'http://bozzuto.com'

          subject.valid?.should == false
        end

        it "has errors on :domain_name" do
          subject.errors[:domain_name].should include('must not include http://')
        end
      end

      context "domain name contains invalid characters" do
        %w(bozzuto com bozzuto;com bozzuto~com bozzuto..com).each do |domain|
          context(domain) do
            before do
              subject.domain_name = 'bozzuto com'

              subject.valid?.should == false
            end

            it "has errors on :domain_name" do
              subject.errors[:domain_name].should include('contains invalid characters')
            end
          end
        end
      end
    end

    context "saving" do
      before do
        subject.domain_name = 'bozzuto.com'

        subject.save
      end

      it "writes the pattern" do
        subject.pattern.should == 'bozzuto.com$'
      end
    end

    describe "#to_s" do
      it "returns the domain name" do
        subject.to_s.should == subject.domain_name
      end
    end
  end

  context "The Ad Source class" do
    before do
      @apartments = AdSource.create(:domain_name => 'apartments.com', :value => 'apartments')
      @rent       = AdSource.create(:domain_name => 'rent.com',       :value => 'rent')
      @blah       = AdSource.create(:domain_name => 'blah.com',       :value => 'blah')
    end

    context "when matching a domain" do
      context "that is root-level" do
        it "returns the match" do
          AdSource.matching('apartments.com').should == @apartments
        end
      end

      context "that is a sub-domain" do
        it "returns the match" do
          AdSource.matching('va.apartments.com').should == @apartments
        end
      end

      context "that does not exist" do
        it "returns nil" do
          AdSource.matching('yay.com').should == nil
        end
      end

      context "that is not present" do
        it "returns nil" do
          AdSource.matching(nil).should == nil
        end
      end
    end
  end
end
