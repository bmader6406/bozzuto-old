require 'test_helper'

module Bozzuto::ExternalFeed
  class FileTest < ActiveSupport::TestCase
    context "File" do
      subject do
        Bozzuto::ExternalFeed::File.new(
          :external_cms_id   => '123',
          :external_cms_type => 'vaultware',
          :active            => true,
          :file_type         => 'Photo',
          :description       => 'Holy photo, batman!',
          :name              => 'Batcave',
          :caption           => 'Bats, weaponry, and leather.',
          :format            => 'image/jpeg',
          :source            => 'http://images.com/batcave.jpg',
          :width             => 500,
          :height            => 500,
          :rank              => 1,
          :ad_id             => 'Ad ID',
          :affiliate_id      => 'Affiliate ID'
        )
      end

      describe "#database_attributes" do
        it "returns a hash of attributes" do
          subject.database_attributes.should == {
            :external_cms_id   => '123',
            :external_cms_type => 'vaultware',
            :active            => true,
            :file_type         => 'Photo',
            :description       => 'Holy photo, batman!',
            :name              => 'Batcave',
            :caption           => 'Bats, weaponry, and leather.',
            :format            => 'image/jpeg',
            :source            => 'http://images.com/batcave.jpg',
            :width             => 500,
            :height            => 500,
            :rank              => 1,
            :ad_id             => 'Ad ID',
            :affiliate_id      => 'Affiliate ID'
          }
        end
      end
    end
  end
end
