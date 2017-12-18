class Micropost < ApplicationRecord
  belongs_to :user
  # 13.17 - Ordering microposts with default_scope
  default_scope -> { order(created_at: :desc) }
  # 13.59 - Adding an image to the micropost !!!
  mount_uploader :picture, PictureUploader
  # 13.5 - Validation for the micropost's user id
  validates :user_id, presence: true
  # 13.8 - Validation for micropost's max length
  validates :content, presence: true, length: { maximum: 140 }
  # 13.65 - Validating image size
  validate  :picture_size

  private

    # 13.65 - Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
