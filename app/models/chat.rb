class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :messages, dependent: :destroy
  has_many :cheat_sheets
end
