require "xing/pdf_cover/version"
require "xing/pdf_cover/converter"

module Xing
  module PdfCover
    module ClassMethods
      def pdf_cover_processor!
        process :pdf_cover

        define_method :full_filename do |for_file = model.logo.file|
          for_file.gsub(/pdf$/, "jpeg")
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def pdf_cover
      converted_file = Xing::PdfCover::Converter.new(file).converted_file
      FileUtils.cp(converted_file, current_path)
    end
  end
end
