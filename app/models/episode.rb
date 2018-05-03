class Episode < ApplicationRecord
  has_many :downloads, dependent: :destroy
  has_many :downloads, dependent: :destroy
end
