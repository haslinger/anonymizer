class CreateAggregateDownloads < ActiveRecord::Migration[5.2]
  def change
    create_table :aggregate_downloads do |t|
      t.references :episode, foreign_key: true
      t.date :day
      t.integer :volume, limit: 8
      t.integer :hits
      t.integer :count

      t.timestamps
    end
  end
end
