class AddScoreToChats < ActiveRecord::Migration[8.1]
  def change
    add_column :chats, :score, :integer
  end
end
