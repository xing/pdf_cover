class WithCarrierwaveUploader < CarrierWave::Uploader::Base
  include PdfCover

  storage :file

  version :image do
    pdf_cover_attachment quality: PdfCover::Converter::DEFAULT_QUALITY,
                         resolution: PdfCover::Converter::DEFAULT_RESOLUTION
  end
end
