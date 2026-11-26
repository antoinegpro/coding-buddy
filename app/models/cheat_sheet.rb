class CheatSheet < ApplicationRecord
  belongs_to :chat

  validates :title, presence: true
  validates :content, presence: true
  validates :chat_id, uniqueness: true
end
