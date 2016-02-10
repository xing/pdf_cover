require "xing/pdf_cover/version"
require "xing/pdf_cover/converter"

module Xing
  module PdfCover
    module ClassMethods
      module CarrierWave
        def pdf_cover_attachment
          process :pdf_cover

          define_method :full_filename do |for_file = model.logo.file|
            for_file.gsub(/pdf$/, "jpeg")
          end
        end
      end

      module Paperclip
        def pdf_cover_attachment(attachment_name, format = :jpeg)
          has_attached_file attachment_name,
            styles: { pdf_cover: {format: format} },
            processors: %i(pdf_cover)

          validates_attachment_content_type attachment_name, content_type: %w(application/pdf)
        end
      end
    end

    def self.included(base)
      if defined?(CarrierWave::Uploader::Base) && base.ancestors.include?(CarrierWave::Uploader::Base)
        base.extend ClassMethods::CarrierWave
      elsif defined?(Paperclip)
        base.extend ClassMethods::Paperclip
      else
        fail "#{base} is not a CarrierWave::Uploader and Paperclip is not defined ¯\\_(ツ)_/¯"
      end
    end

    def pdf_cover
      converted_file = Xing::PdfCover::Converter.new(file).converted_file
      FileUtils.cp(converted_file, current_path)
    end
  end
end
