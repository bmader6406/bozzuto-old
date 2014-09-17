require 'test_helper'

class CarouselPanelTest < ActiveSupport::TestCase
  context 'A carousel panel' do
    setup { @panel = CarouselPanel.new }

    subject { @panel }

    should belong_to(:carousel)

    should have_attached_file(:image)
    should validate_presence_of(:link_url)
    should validate_presence_of(:carousel)

    context 'when caption is set' do
      setup { @panel.caption = 'yay' }

      should validate_presence_of(:heading)
    end

    context 'when heading is set' do
      setup { @panel.heading = 'yay' }

      should validate_presence_of(:caption)
    end
  end
end
