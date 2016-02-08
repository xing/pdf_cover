# Xing::PdfCover

With this gem you can easily have attachments for PDF files that have associated
images generated for their first page.

Support is provided both for [Paperclip](https://github.com/thoughtbot/paperclip)
and [CarrierWave](https://github.com/carrierwaveuploader/carrierwave).

## Paperclip Support

To add a PDF cover style to your attachments you can do something like this:

```Ruby
class WithPaperclip < ActiveRecord::Base
  has_attached_file :pdf, styles: { pdf_cover: {} }, processors: %i(pdf_cover)

  validates_attachment_content_type :pdf, content_type: %w(application/pdf)
end
```

## CarrierWave

When using CarrierWave you can implement this gem's functionality
you can do something like this:

```Ruby
class WithCarrierwaveUploader < CarrierWave::Uploader::Base
  include Xing::PdfCover

  storage :file

  version :image do
    process :pdf_cover
  end
end
```
