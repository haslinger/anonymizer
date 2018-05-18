class Episode < ApplicationRecord
  has_many :downloads, dependent: :destroy
  belongs_to :podcast, foreign_key: "podcast",
                       primary_key: 'name'
end
