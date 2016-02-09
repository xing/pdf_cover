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

# Developing this gem

After cloning this gem locally just run the `bin/setup` script to set everything
up. This will:

- Run `bundle` to install the development dependencies
- Initialize the database used by the `spec/dummy` rails application that
we use to test the ActiveRecord+(Paperclip|CarrierWave) integration.

## Running the specs

Once you have setup the gem locally you can just run `rake` from the root folder
of the gem to run the specs.

This will run the specs that are considered fast, but there is another set of
specs that are marked as *SLOW* using a rspec tag, and which won't be run by
default when using rake.

The reason this specs are slow is because they use an included sample of PDFs
to check if the gem generates the correct images for them. This PDFs are sometimes
quite big and so they take a while to process.

To run all the specs, including the slow ones, use the following command:

```Shell
RUN_SLOW_SPECS=1 rake # This will take 10 minutes, go get a coffee!
```
