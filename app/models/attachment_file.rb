class AttachmentFile < Asset

  has_attached_file :data,
                    :url => '/system/assets/attachments/:id/:filename'

  do_not_validate_attachment_file_type :data

  validates_attachment_size :data, :less_than=>10.megabytes
end
