require 'test_helper'

class ContactSubmissionsHelperTest < ActionView::TestCase
  context 'ContactSubmissionsHlper' do
    context '#contact_path_with_topic' do
      context 'when section is a service' do
        setup do
          @section = Section.make(:service, :title => 'Construction')
        end

        should 'set the topic to service' do
          assert_equal contact_path(:topic => 'construction'),
            contact_path_with_topic
        end
      end

      context 'when section is not a service' do
        setup do
          @section = Section.make
        end

        should 'set the topic to general_inquiry' do
          assert_equal contact_path(:topic => 'general_inquiry'),
            contact_path_with_topic
        end
      end
    end
  end
end
