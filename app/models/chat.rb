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

  def conversation_messages
    messages.where(kind: "conversation").order(:id)
  end

  def quiz_mistakes
    incorrect_answers.includes(:question).map do |answer|
      {
      topic: answer.question.topic,
      question: answer.question.content,
      user_answer: answer.content,
      correct_answer: answer.question.choices[answer.question.correct_option],
      feedback: answer.question.feedback
     }
    end
  end

  MAX_EXCHANGES = 3

  def exchanges_count
    conversation_messages.where(role: "user").count
  end

  def remaining_exchanges
    [MAX_EXCHANGES - exchanges_count, 0].max
  end

  def discussion_limit_reached?
    remaining_exchanges.zero?
  end
end
