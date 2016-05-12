require "spec_helper"
require File.expand_path("../../dummy/config/environment.rb", __FILE__)

describe WithCarrierwave do
  context "attachment post processing" do
    let(:base_pdf_name) { "spec/test_pdfs/Test" }

    let(:pdf_cover) { Magick::Image.read(pdf_cover_path).first }
    let(:pdf_cover_digest) { pdf_cover.signature }
    let(:pdf_cover_path) { subject.pdf.image.path }

    let(:sample_image) { Magick::Image.read(sample_image_name).first }
    let(:sample_image_digest) { sample_image.signature }
    let(:sample_image_name) { "#{base_pdf_name}.jpg" }

    shared_examples "handling file extension" do
      before do
        subject.pdf = File.new("#{base_pdf_name}.#{extension}")
        subject.save!
      end

      it "creates the pdf cover image" do
        expect(pdf_cover_path).to match(/.*jpeg$/)
        expect(pdf_cover_digest).to eq(sample_image_digest)
      end
    end

    context "extension is lowercase" do
      let(:extension) { "pdf" }

      it_behaves_like "handling file extension"
    end

    context "extension is lowercase" do
      let(:extension) { "PDF" }

      it_behaves_like "handling file extension"
    end
  end
end
