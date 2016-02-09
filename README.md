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

The relevant part here is just the `processors: %i(pdf_cover)` which tells Paperclip
to apply the processor provided by this gem on the given attachment. The rest
of this class can be understood by checking Paperclip's documentation.

## CarrierWave

When using CarrierWave you can implement this gem's functionality
you can do something like this:

```Ruby
class WithCarrierwaveUploader < CarrierWave::Uploader::Base
  include Xing::PdfCover

  storage :file

  version :image do
    pdf_cover_processor!
  end
end
```

In this case, when we mix the `Xing::PdfCover` module in, it adds the `pdf_cover_processor!`
method to our uploader. We only need to call it inside one of our versions to get the
pdf to image feature.
