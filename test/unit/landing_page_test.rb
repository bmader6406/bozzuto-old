require 'test_helper'

class LandingPageTest < ActiveSupport::TestCase
  context 'LandingPage' do
    setup do
      @page = LandingPage.make
    end

    subject { @page }

    should_have_and_belong_to_many :apartment_communities,
      :featured_apartment_communities,
      :home_communities,
      :projects
    should_belong_to :state, :promo
    should_have_many :popular_properties

    should_validate_presence_of :title, :state
    should_validate_uniqueness_of :title
    should_have_attached_file :masthead_image
  end
end
