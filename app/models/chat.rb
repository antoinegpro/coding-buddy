class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :cheat_sheets
  has_many :messages, dependent: :destroy

  def quiz_questions
    messages.where(kind: "quiz_question").order(:id)
  end

  def quiz_answers
    messages.where(kind: "quiz_answer").order(:id)
  end

  def current_question
    quiz_questions.where.not(
      id: quiz_answers.select(:question_id)
    ).first
  end

  def correct_answers
    quiz_answers.where(correct: true)
  end

  def incorrect_answers
    quiz_answers.where(correct: false)
  end

  def score
    correct_answers.count
  end

  def completed?
    quiz_questions.exists? && current_question.nil?
  end
end
