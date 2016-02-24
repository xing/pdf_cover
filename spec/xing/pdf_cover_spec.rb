require "spec_helper"

describe PdfCover do
  it "has a version number" do
    expect(PdfCover::VERSION).not_to be nil
  end

  let(:base) { Class.new }

  context "CarrierWave is included in the base module" do
    before do
      expect(described_class).to receive(:carrierwave_defined?).with(base).and_return(true)
      expect(base).to receive(:extend).with(PdfCover::ClassMethods::CarrierWave)
      expect(base).not_to receive(:extend).with(PdfCover::ClassMethods::Paperclip)
    end

    it "includes the carrierwave helper method" do
      base.send(:include, described_class)
    end
  end

  context "Paperclip module is defined" do
    before do
      expect(described_class).to receive(:carrierwave_defined?).with(base).and_return(false)
      expect(described_class).to receive(:paperclip_defined?).and_return(true)
      expect(base).not_to receive(:extend).with(PdfCover::ClassMethods::CarrierWave)
      expect(base).to receive(:extend).with(PdfCover::ClassMethods::Paperclip)
    end

    it "includes the carrierwave helper method" do
      base.send(:include, described_class)
    end
  end

  context "neither CarrierWave or Paperclip are available" do
    before do
      expect(described_class).to receive(:carrierwave_defined?).with(base).and_return(false)
      expect(described_class).to receive(:paperclip_defined?).and_return(false)
      expect(base).not_to receive(:extend).with(PdfCover::ClassMethods::CarrierWave)
      expect(base).not_to receive(:extend).with(PdfCover::ClassMethods::Paperclip)
    end

    it "raises an error" do
      expect { base.send(:include, described_class) }
        .to raise_error("#{base} is not a CarrierWave::Uploader and Paperclip is not defined ¯\\_(ツ)_/¯")
    end
  end
end
