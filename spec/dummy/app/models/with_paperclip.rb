require "paperclip/pdf_cover"

class WithPaperclip < ActiveRecord::Base
  include PdfCover

  pdf_cover_attachment :pdf, styles: { pdf_cover: ['', :jpg]},
    convert_options: { all: "-quality #{PdfCover::Converter::DEFAULT_QUALITY}" }

  validates_attachment_content_type :pdf, content_type: %w(application/pdf)
end
