require "spec_helper"
require "pdf_cover/converter"

describe PdfCover::Converter do
  subject { described_class.new(source_file) }

  let(:source_file) { double(File, path: "original_path") }
  let(:destination_file) { double(File, path: "destination_path") }

  describe "#initialize" do
    subject { described_class.new(source_file, options) }

    context "parameter provided" do
      let(:format) { "jpg" }
      let(:quality) { "89" }
      let(:options) do
        {
          format: format,
          quality: quality,
          resolution: resolution,
          antialiasing: antialiasing,
        }
      end
      let(:resolution) { "273" }
      let(:antialiasing) { "3" }

      context "all parameters are ok" do
        it "saves the parameters" do
          expect(subject.instance_variable_get(:@format)).to eq(format)
          expect(subject.instance_variable_get(:@quality)).to eq(quality.to_i)
          expect(subject.instance_variable_get(:@resolution)).to eq(resolution.to_i)
          expect(subject.instance_variable_get(:@antialiasing)).to eq(antialiasing.to_i)
        end
      end

      context "format is invalid" do
        let(:format) { "gif" }

        it "raises an error" do
          expect { subject }.to raise_error(PdfCover::Converter::InvalidOption)
        end
      end

      context "quality is invalid" do
        let(:quality) { -10 }

        it "raises an error" do
          expect { subject }.to raise_error(PdfCover::Converter::InvalidOption)
        end
      end

      context "resolution is invalid" do
        let(:resolution) { -10 }

        it "raises an error" do
          expect { subject }.to raise_error(PdfCover::Converter::InvalidOption)
        end
      end

      context "antialiasing is invalid" do
        let(:antialiasing) { 0 }

        it "raises an error" do
          expect { subject }.to raise_error(PdfCover::Converter::InvalidOption)
        end
      end
    end

    context "parameters not provided" do
      let(:options) { {} }

      it "uses the default values" do
        expect(subject.instance_variable_get(:@format))
          .to eq(described_class::DEFAULT_FORMAT)
        expect(subject.instance_variable_get(:@quality))
          .to eq(described_class::DEFAULT_QUALITY)
        expect(subject.instance_variable_get(:@resolution))
          .to eq(described_class::DEFAULT_RESOLUTION)
        expect(subject.instance_variable_get(:@antialiasing))
          .to eq(described_class::DEFAULT_ANTIALIASING)
      end
    end
  end

  describe "#converted_file" do
    context "general logic" do
      before do
        expect(subject).to receive(:destination_file)
          .and_return(destination_file)
          .at_least(:once)
        expect(subject).to receive(:execute_command)
          .and_return(execution_result)
      end

      context "the conversion goes fine" do
        let(:execution_result) { ["", "", 0] }

        it "returns the generated file" do
          expect(subject.converted_file).to eq(destination_file)
        end
      end

      context "the conversion fails" do
        before do
          expect(destination_file).to receive(:close)
        end

        context "because the command execution failed" do
          let(:execution_result) { ["", "", 1] }
          let(:logger) { double(Logger) }

          it "generates an error" do
            expect { subject.converted_file }.to raise_error(PdfCover::Converter::CommandFailedError)
          end
        end

        context "because the GhostScript command is not found" do
          let(:execution_result) { ["", "", 127] }

          it "generates an error" do
            expect { subject.converted_file }.to raise_error(PdfCover::Converter::CommandNotFoundError)
          end
        end
      end
    end

    context "conversion samples" do
      Dir.foreach("spec/test_pdfs") do |file_name|
        next unless file_name =~ /.pdf$/

        context "for the file #{file_name}" do
          let(:converted_image) { Magick::Image.read(subject.converted_file.path).first }
          let(:converted_image_digest) { converted_image.signature }
          let(:sample_image) { Magick::Image.read(sample_image_name).first }
          let(:sample_image_digest) { sample_image.signature }
          let(:sample_image_name) { "spec/test_pdfs/#{file_name.gsub(/.pdf$/, '.jpg')}" }

          subject { described_class.new(File.open("spec/test_pdfs/#{file_name}")) }

          it "converts the image as expected" do
            expect(converted_image_digest).to eq(sample_image_digest)
          end
        end
      end
    end
  end
end
