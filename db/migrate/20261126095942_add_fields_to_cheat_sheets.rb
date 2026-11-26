class AddFieldsToCheatSheets < ActiveRecord::Migration[8.1]
  def change
    add_column :cheat_sheets, :title, :string, null: false
    add_column :cheat_sheets, :content, :text, null: false

    remove_index :cheat_sheets, :chat_id
    add_index :cheat_sheets, :chat_id, unique: true
  end
end
