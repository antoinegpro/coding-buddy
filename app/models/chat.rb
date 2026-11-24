class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :cheat_cheats
  has_many :messages, dependent: :destroy
end
