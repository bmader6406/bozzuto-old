Paperclip.options[:command_path] = APP_CONFIG[:paperclip_command_path]

Paperclip.interpolates :attachment_name do |attachment, style|
  attachment.name.to_s.downcase
end

# :nocov:
Paperclip::Attachment.class_eval do
  def file_missing?
    file? && !File.exists?(path)
  end
end
# :nocov:
