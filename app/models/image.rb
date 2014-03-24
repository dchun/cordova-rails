class Image < ActiveRecord::Base
  belongs_to :job
  mount_uploader :pic, ImageUploader
end