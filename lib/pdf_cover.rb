require "pdf_cover/version"
require "pdf_cover/converter"

# This module provides methods for CarrierWave::Uploader::Base subclasses and
# for ActiveRecord models that want to include attachments to simplify the
# generation of JPEG images from the first page of a PDF file that is uploaded
# by the users.
# Include this module in your class and check the `ClassMethods` documentation
# that corresponds to your attachments managing library in this same file.
module PdfCover
  module ClassMethods
    module CarrierWave
      # When called in the context of a CarrierWave::Uploader::Base subclass,
      # this method will add a processor to the currenct attachment or version
      # that generates a JPEG with 95 quality from the first page of the given
      # PDF.
      #
      # This will not make any validation on the given content type, you must
      # [do it yourself](https://github.com/carrierwaveuploader/carrierwave#securing-uploads)
      # on your uploader.
      #
      # @example Adding a version to your uploader:
      #   class WithCarrierwaveUploader < CarrierWave::Uploader::Base
      #     include PdfCover
      #
      #     storage :file
      #
      #     version :image do
      #       pdf_cover_attachment
      #     end
      #   end
      def pdf_cover_attachment(options = {})
        process pdf_cover: [options[:quality], options[:resolution]]

        define_method :full_filename do |for_file = model.logo.file|
          for_file.gsub(/pdf$/, "jpeg")
        end
      end
    end

    module Paperclip
      # Adds a new attached file to the caller that has the pdf cover processors
      # prepended to the list of processors given.
      #
      # @param attachment_name [Symbol] the name of the new attachment. The fields
      # described in the Paperclip documentation for attachments are needed for this one.
      # @param options [Hash] the same options that are accepted by Paperclip, they
      # are passed to the has_attached_file call with just a new processor
      # prepended to the given ones. The PdfCover processor will use the quality
      # provided in the `convert_options` option when generating the jpeg.
      #
      # @example A sample ActiveRecord model with a pdf_cover attachment:
      #   class WithPaperclip < ActiveRecord::Base
      #     include PdfCover
      #
      #     pdf_cover_attachment :pdf, styles: { pdf_cover: ['', :jpeg]},
      #       convert_options: { all: '-quality 95 -density 300' }
      #
      #     # Note that you must set content type validation as required by Paperclip
      #     validates_attachment_content_type :pdf, content_type: %w(application/pdf)
      #   end
      def pdf_cover_attachment(attachment_name, options = {})
        options[:processors] = (options[:processors] || []).unshift(:pdf_cover_processor)

        has_attached_file attachment_name, options
      end
    end
  end

  class << self
    def included(base)
      if carrierwave_defined?(base)
        base.extend ClassMethods::CarrierWave
      elsif paperclip_defined?
        require "paperclip/pdf_cover_processor"
        base.extend ClassMethods::Paperclip
      else
        fail "#{base} is not a CarrierWave::Uploader and Paperclip is not defined ¯\\_(ツ)_/¯"
      end
    end

    private

    def carrierwave_defined?(base)
      defined?(CarrierWave::Uploader::Base) && base.ancestors.include?(CarrierWave::Uploader::Base)
    end

    def paperclip_defined?
      defined?(Paperclip)
    end
  end

  # This is the method used by the CarrierWave processor mechanism
  def pdf_cover(quality, resolution)
    options = { quality: quality, resolution: resolution }.compact
    converted_file = PdfCover::Converter.new(file, options).converted_file
    FileUtils.cp(converted_file, current_path)
  end
end
