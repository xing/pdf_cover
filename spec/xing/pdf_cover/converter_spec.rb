require "spec_helper"
require "xing/pdf_cover/converter"

describe Xing::PdfCover::Converter do
  subject { described_class.new(source_file, format) }

  let(:source_file) { double(File, path: "original_path") }
  let(:destination_file) { double(File, path: "destination_path") }
  let(:format) { nil }

  describe "#converted_file" do
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

        before do
          $CHILD_STATUS = "something went wrong"
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
end
