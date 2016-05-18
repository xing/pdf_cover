require "open3"

module PdfCover
  class Converter
    # NOTE: Update the generate_jpegs.sh script when changing these values
    DEFAULT_FORMAT = "jpeg"
    DEFAULT_QUALITY = 85
    DEFAULT_RESOLUTION = 300

    class CommandFailedError < StandardError
      def initialize(stdout_str, stderr_str)
        super("PDF conversion failed:\nSTDOUT: #{stdout_str}\nSTDERR: #{stderr_str}")
      end
    end

    class CommandNotFoundError < StandardError
      def initialize
        super("Could not run the `gs` command. Make sure that GhostScript is in your PATH.")
      end
    end

    class InvalidOption < StandardError
      def initialize(option_name, option_value)
        super("Invalid option '#{option_name}' with value: '#{option_value}'")
      end
    end

    def initialize(file, options = {})
      @file = file
      extract_options(options)
    end

    # @raises PdfCover::Converter::CommandNotFoundError if GhostScript is not found
    # @raises PdfCover::Converter::CommandFailedError if GhostScript returns a non-zero status
    def converted_file
      parameters = build_parameters(file_path, device)
      stdout_str, stderr_str, status = execute_command("gs #{parameters}")

      case status
        when 0 then destination_file
        when 127 then fail CommandNotFoundError
        else fail CommandFailedError.new(stdout_str, stderr_str)
      end
    rescue => e
      destination_file.close
      raise e
    end

    private

    def basename
      @basename ||= File.basename(@file.path, File.extname(@file.path))
    end

    def build_parameters(source, device)
      %W(-sOutputFile='#{destination_path}' -dNOPAUSE
         -sDEVICE='#{device}' -dJPEGQ=#{@quality}
         -dFirstPage=1 -dLastPage=1
         -r#{@resolution} -q '#{source}'
         -c quit
      ).join(" ")
    end

    def destination_file
      @destination_file ||= Tempfile.new([basename, ".#{@format}"]).tap do |file|
        file.binmode
      end
    end

    def destination_path
      File.expand_path(destination_file.path)
    end

    def device
      @format.to_s == "jpg" ? "jpeg" : @format.to_s
    end

    def execute_command(command)
      Open3.capture3(command)
    end

    def extract_options(options)
      @format = options.fetch(:format, DEFAULT_FORMAT)
      @quality = options.fetch(:quality, DEFAULT_QUALITY).to_i
      @resolution = options.fetch(:resolution, DEFAULT_RESOLUTION).to_i

      fail InvalidOption.new(:format, @format) unless %w(jpg jpeg png).include?(@format)
      fail InvalidOption.new(:quality, @quality) unless @quality.between?(1, 100)
      fail InvalidOption.new(:resolution, @resolution) unless @resolution > 1
    end

    def file_path
      @file_path ||= File.expand_path(@file.path)
    end
  end
end
