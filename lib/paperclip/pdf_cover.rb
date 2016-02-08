if Kernel.const_defined?(:Paperclip)
  require "xing/pdf_cover/converter"

  module Paperclip
    # This is a Paperclip::Processor that can be used to generate an image
    # from a PDF file. The image is only of the first page.
    #
    # We inherit the following instance variables from Paperclip::Processor:
    #   @file the file that will be operated on (which is an instance of File)
    #   @options a hash of options that were defined in has_attached_file's style hash
    #   @attachment the Paperclip::Attachment itself

    class PdfCover < Processor
      def make
        Xing::PdfCover::Converter.new(@file).converted_file
      end
    end
  end
end
