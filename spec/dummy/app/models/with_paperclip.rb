require "paperclip/pdf_cover"

class WithPaperclip < ActiveRecord::Base
  include Xing::PdfCover

  pdf_cover_attachment :pdf
end
