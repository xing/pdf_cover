if Kernel.const_defined?(:Paperclip)
  require "pdf_cover/converter"

  module Paperclip
    # This is a Paperclip::Processor that can be used to generate an image
    # from a PDF file. The image is only of the first page.
    #
    # We inherit the following instance variables from Paperclip::Processor:
    #   @file the file that will be operated on (which is an instance of File)
    #   @options a hash of options that were defined in has_attached_file's style hash
    #   @attachment the Paperclip::Attachment itself
    class PdfCover < Processor
      QUALITY_CONVERT_OPTION_REGEX = /-quality\s+(?<quality>\d+)/

      def make
        ::PdfCover::Converter.new(@file, format: format, quality: jpeg_quality)
          .converted_file
      end

      def format
        @options[:format].to_s
      end

      def jpeg_quality
        return nil unless %w(jpeg jpg).include?(format)

        match_data = QUALITY_CONVERT_OPTION_REGEX.match(@options[:convert_options])
        match_data && match_data[:quality]
      end
    end
  end
end
