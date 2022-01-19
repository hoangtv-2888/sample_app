class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  scope :relate_post, ->(user){where user_id: user.following_ids << user.id}
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.max_post_length}
  validates :image, content_type: {in: Settings.image_type,
                                   message: :invalid_format},
                    size: {less_than: Settings.max_image_size.megabytes,
                           message: :large_size}
  def display_image
    image.variant resize_to_limit: [Settings.image_limit, Settings.image_limit]
  end
end
