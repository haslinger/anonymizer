class Episode < ApplicationRecord
  has_many :downloads, dependent: :destroy
  has_many :aggregate_downloads, dependent: :destroy
end
