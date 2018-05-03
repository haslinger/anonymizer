class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.string :podcast
      t.string :name
      t.integer :number
      t.string :filesize

      t.timestamps
    end
  end
end
