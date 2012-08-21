require 'test_helper'

class CareersEntryTest < ActiveSupport::TestCase
  should_validate_presence_of :name, :company, :job_title, :job_description

  should_validate_attachment_presence :main_photo
  should_validate_attachment_presence :headshot
end
