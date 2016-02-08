class WithCarrierwaveUploader < CarrierWave::Uploader::Base
  include Xing::PdfCover

  storage :file

  version :image do
    process :pdf_cover
  end
end
