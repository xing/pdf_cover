require "spec_helper"
require File.expand_path("../../dummy/config/environment.rb", __FILE__)

describe WithCarrierwave do
  context "attachment post processing", slow: true do
    let(:base_pdf_name) { "spec/test_pdfs/Test" }

    let(:pdf_cover) { Magick::Image.read(pdf_cover_path).first }
    let(:pdf_cover_digest) { Digest::MD5.hexdigest pdf_cover.export_pixels.join }
    let(:pdf_cover_path) { subject.pdf.image.path }

    let(:sample_image) { Magick::Image.read(sample_image_name).first }
    let(:sample_image_digest) { Digest::MD5.hexdigest sample_image.export_pixels.join }
    let(:sample_image_name) { "#{base_pdf_name}.jpg" }

    before do
      subject.pdf = File.new("#{base_pdf_name}.pdf")
      subject.save!
    end

    it "creates the pdf cover image" do
      expect(pdf_cover_path).to match(/.*jpeg$/)
      expect(pdf_cover_digest).to eq(sample_image_digest)
    end
  end
end
