require "paperclip/pdf_cover"

class WithPaperclip < ActiveRecord::Base
  has_attached_file :pdf, styles: { pdf_cover: {format: :jpeg} }, processors: %i(pdf_cover)

  validates_attachment_content_type :pdf, content_type: %w(application/pdf)
end
