class Message < ApplicationRecord
  belongs_to :chat

  belongs_to :question,
             class_name: "Message",
             optional: true

  validates :content, presence: true

  validates :question, presence: true,
            if: :quiz_answer?

  validates :correct,
            inclusion: { in: [true, false] },
            if: :quiz_answer?

  def quiz_answer?
    kind == "quiz_answer"
  end
end
