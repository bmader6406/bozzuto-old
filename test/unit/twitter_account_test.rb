require 'test_helper'

class TwitterAccountTest < ActiveSupport::TestCase
  context 'A TwitterAccount' do
    setup { @account = TwitterAccount.make }

    subject { @account }

    should_validate_presence_of :username
    should_validate_uniqueness_of :username
  end
end
