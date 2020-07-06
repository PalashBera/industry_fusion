Paperclip::Attachment.default_options[:default_url] = "/images/missing_image.jpg"
Paperclip::Attachment.default_options[:path] = ":rails_root/public/uploads/:class/:attachment/:id/:style/:filename"
Paperclip::Attachment.default_options[:url] = "/uploads/:class/:attachment/:id/:style/:filename"
