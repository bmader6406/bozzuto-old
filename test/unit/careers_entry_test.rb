require 'test_helper'

class CareersEntryTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:company)
  should validate_presence_of(:job_title)
  should validate_presence_of(:job_description)

  should validate_attachment_presence(:main_photo)
  should validate_attachment_presence(:headshot)
end
