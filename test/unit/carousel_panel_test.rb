require 'test_helper'

class CarouselPanelTest < ActiveSupport::TestCase
  context 'A carousel panel' do
    setup { @panel = CarouselPanel.new }

    subject { @panel }

    should_belong_to :carousel

    should_have_attached_file :image
    should_validate_presence_of :link_url, :carousel

    context 'when caption is set' do
      setup { @panel.caption = 'yay' }

      should_validate_presence_of :heading
    end

    context 'when heading is set' do
      setup { @panel.heading = 'yay' }

      should_validate_presence_of :caption
    end
  end
end
