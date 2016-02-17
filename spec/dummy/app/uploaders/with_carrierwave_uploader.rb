class WithCarrierwaveUploader < CarrierWave::Uploader::Base
  include PdfCover

  storage :file

  version :image do
    pdf_cover_attachment
  end
end
