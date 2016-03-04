class FileUpload < ActiveRecord::Base
  has_attached_file :file, url: '/system/:class/:id/:filename'

  do_not_validate_attachment_file_type :file

  validates :file, presence: true
end
