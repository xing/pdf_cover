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
      RESOLUTION_CONVERT_OPTION_REGEX = /-density\s+(?<resolution>\d+)/

      def make
        ::PdfCover::Converter.new(@file, converter_options).converted_file
      end

      def converter_options
        format.merge(jpeg_quality).merge(jpeg_resolution)
      end

      def format
        { format: @options[:format].to_s }
      end

      def jpeg_quality
        return {} unless %w(jpeg jpg).include?(format)

        match_data = QUALITY_CONVERT_OPTION_REGEX.match(@options[:convert_options])
        quality = match_data && match_data[:quality]

        quality ? { quality: quality } : {}
      end

      def jpeg_resolution
        match_data = RESOLUTION_CONVERT_OPTION_REGEX.match(@options[:convert_options])
        resolution = match_data && match_data[:resolution]

        resolution ? { resolution: resolution } : {}
      end
    end
  end
end
