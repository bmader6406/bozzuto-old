Paperclip.options[:command_path] = APP_CONFIG[:paperclip_command_path]

Paperclip.interpolates :attachment_name do |attachment, style|
  attachment.name.to_s.downcase
end
