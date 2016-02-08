module Xing
  module PdfCover
    class Converter
      class CommandNotFoundError < StandardError
        def initialize
          super("Could not run the `gs` command. Make sure that GhostScript is in your PATH.")
        end
      end

      def initialize(file, format = "jpeg")
        @file = file
        @format = format
      end

      # @raises PdfCover::Converter::CommandNotFoundError if GhostScript is not found
      def converted_file
        case convert_file
          when :ok
            destination_file
          when :command_failed
            @file # TODO: Why this? Shouldn't we just crash?
          when :command_not_found
            fail CommandNotFoundError
        end
      end

      private

      def basename
        @basename ||= File.basename(@file.path, File.extname(@file.path))
      end

      def build_parameters(source, device, destination)
        %W(
          -sOutputFile='#{destination}'
          -dNOPAUSE
          -sDEVICE='#{device}'
          -dFirstPage=1
          -dLastPage=1
          -r300
          -q '#{source}'
          -c quit
        ).join(" ")
      end

      def convert_file
        parameters = build_parameters(file_path, device, File.expand_path(destination_file.path))
        result = execute_command("gs #{parameters}")

        if result
          :ok
        else
          failed_result(result)
        end
      end

      def destination_file
        @destination_file ||= Tempfile.new([basename, ".#{@format}"]).tap do |file|
          file.binmode
        end
      end

      def device
        @format.to_s == "jpg" ? "jpeg" : @format.to_s
      end

      def execute_command(command)
        Kernel.system(command)
      end

      def failed_result(result)
        destination_file.close

        if result == false
          logger.warn("GhostScript execution failed: #{$CHILD_STATUS}")
          :command_failed
        else
          :command_not_found
        end
      end

      def file_path
        @file_path ||= File.expand_path(@file.path)
      end

      def logger
        @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDERR)
      end
    end
  end
end
