# PdfCover

![Build Status](https://api.travis-ci.org/xing/pdf_cover.svg)

With this gem you can easily have attachments for PDF files that have associated
images generated for their first page.

Support is provided both for [Paperclip](https://github.com/thoughtbot/paperclip)
and [CarrierWave](https://github.com/carrierwaveuploader/carrierwave).

## Paperclip Support

To add a PDF cover style to your attachments you can do something like this:

```Ruby
class WithPaperclip < ActiveRecord::Base
  include PdfCover

  pdf_cover_attachment :pdf, styles: { pdf_cover: ['', :jpeg]},
    convert_options: { all: '-quality 95' },

  validates_attachment_content_type :pdf, content_type: %w(application/pdf)
end
```

This will define an attachment called `pdf` which has a `pdf_cover` style attached
to it that is a JPEG of the first page in the PDF. You can pass any option that you
would normally pass to `has_attached_file` in the options hash and it will be
passed through to the underlying `has_attached_file` call.

## CarrierWave

When using CarrierWave you can implement this gem's functionality
you can do something like this:

```Ruby
class WithCarrierwaveUploader < CarrierWave::Uploader::Base
  include PdfCover

  storage :file

  version :image do
    pdf_cover_attachment
  end
end
```

In this case, when we mix the `PdfCover` module in, it adds the `pdf_cover_attachment`
method to our uploader. We only need to call it inside one of our versions to get the
pdf to image feature.

# Developing this gem

After cloning this gem locally just run the `bin/setup` script to set everything
up. This will:

- Run `bundle` to install the development dependencies
- Initialize the database used by the `spec/dummy` rails application that
we use to test the ActiveRecord+(Paperclip|CarrierWave) integration.

## Running the specs

Once you have setup the gem locally you can just run `rake` from the root folder
of the gem to run the specs.
