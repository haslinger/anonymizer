class Episode < ApplicationRecord
  has_many :downloads, dependent: :destroy
  belongs_to :thepodcast, class_name: "Podcast",
                          foreign_key: "podcast",
                          primary_key: 'name'
end
