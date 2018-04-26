class CreateDownloads < ActiveRecord::Migration[5.2]
  def change
    create_table :downloads do |t|
      t.references :episode, foreign_key: true
      t.date :day
      t.integer :size, limit: 8

      t.timestamps
    end
  end
end
