require "xing/pdf_cover/version"
require "xing/pdf_cover/converter"

module Xing
  module PdfCover
    def pdf_cover
      converted_file = Xing::PdfCover::Converter.new(file).converted_file
      FileUtils.cp(converted_file, current_path)
    end
  end
end
