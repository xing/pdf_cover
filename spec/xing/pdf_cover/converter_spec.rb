require "rmagick"

require "spec_helper"
require "xing/pdf_cover/converter"

describe Xing::PdfCover::Converter do
  subject { described_class.new(source_file) }

  let(:source_file) { double(File, path: "original_path") }
  let(:destination_file) { double(File, path: "destination_path") }

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
        let(:execution_result) { true }

        it "returns the generated file" do
          expect(subject.converted_file).to eq(destination_file)
        end
      end

      context "the conversion fails" do
        before do
          expect(destination_file).to receive(:close)
        end

        context "because the command execution failed" do
          let(:execution_result) { false }
          let(:logger) { double(Logger) }

          const_set(:CHILD_STATUS, "something went wrong")

          before do
            expect(subject).to receive(:logger).and_return(logger)
            expect(logger).to receive(:warn)
          end

          it "returns the original file" do
            expect(subject.converted_file).to eq(source_file)
          end
        end

        context "because the GhostScript command is not found" do
          let(:execution_result) { nil }

          it "generates an error" do
            expect { subject.converted_file }.to raise_error(Xing::PdfCover::Converter::CommandNotFoundError)
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
