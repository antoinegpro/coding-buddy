class AddQuizFieldsToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :kind, :string, default: "conversation", null: false
    add_column :messages, :choices, :jsonb, default: [], null: false
    add_column :messages, :correct_option, :integer
    add_column :messages, :correct, :boolean
    add_column :messages, :feedback, :text
    add_column :messages, :topic, :string

    add_reference :messages, :question,
                  foreign_key: { to_table: :messages, on_delete: :cascade }

    add_index :messages, [:chat_id, :question_id], unique: true
  end
end
