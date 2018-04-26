class AddFilesizeAndNumberToEpisodes < ActiveRecord::Migration[5.2]
  def change
    change_table :episodes do |t|
      t.integer :number
      t.string :filesize
    end
  end
end
