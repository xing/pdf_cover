class WithPaperclip < ActiveRecord::Base
  include PdfCover

  pdf_cover_attachment :pdf, styles: { pdf_cover: ['', :jpg]},
    convert_options: {
      all: "-quality #{PdfCover::Converter::DEFAULT_QUALITY} -density #{PdfCover::Converter::DEFAULT_RESOLUTION}"
    }

  validates_attachment_content_type :pdf, content_type: %w(application/pdf)
end
