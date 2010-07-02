require 'test_helper'

class DummyPost < ActiveRecord::Base
  has_no_table

  column :title, :string
  column :body,  :text
end

class ActiveRecordTipTest < ActiveSupport::TestCase
  context 'ActiveRecord Tip plugin' do
    context '#human_tip_text' do
      setup do
        @title = 'TITLE!'

        I18n.backend.store_translations :en,
          :activerecord => {
            :tips => {
              :dummy_post => {
                :title => @title
              }
            }
          }
      end

      context 'and a tip translation exists' do
        should 'return the translation' do
          assert_equal @title, DummyPost.human_tip_text(:title)
        end
      end

      context 'and no tip translation exists' do
        should 'return an empty string' do
          assert_equal '', DummyPost.human_tip_text(:body)
        end
      end
    end
  end
end
