require 'carrierwave/orm/activerecord'

class WithCarrierwave < ActiveRecord::Base
  mount_uploader :pdf, WithCarrierwaveUploader
end
