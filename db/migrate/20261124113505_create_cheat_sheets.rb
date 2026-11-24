class CreateCheatSheets < ActiveRecord::Migration[8.1]
  def change
    create_table :cheat_sheets do |t|
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
