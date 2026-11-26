class ChatsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])

    questions = generate_quiz_questions(@category)

    if questions.empty?
      redirect_to root_path, alert: "Impossible de générer le quiz."
      return
    end

    @chat = Chat.new(title: "Quiz #{@category.name}")
    @chat.category = @category
    @chat.user = current_user

    Chat.transaction do
      @chat.save!

      questions.each do |question|
        @chat.messages.create!(
          role: "assistant",
          kind: "quiz_question",
          content: question["question"],
          choices: question["choices"],
          correct_option: question["correct_option"],
          feedback: question["feedback"],
          topic: question["topic"]
        )
      end
    end

    redirect_to chat_path(@chat)
  rescue ActiveRecord::RecordInvalid
    @chats = @category.chats.where(user: current_user)
    render "categories/show", status: :unprocessable_entity
  end

  def show
    @chat = current_user.chats.find(params[:id])

    @total = @chat.quiz_questions.count
    @answered = @chat.quiz_answers.count

    return redirect_to root_path if @total.zero?

    return redirect_to companion_chat_path(@chat) if @chat.completed?

    return redirect_to root_path, alert: "Quiz incohérent." if @answered >= @total

    @question = @chat.current_question
    @last_answer = @chat.quiz_answers.last
    @position = @answered + 1
  end

  def companion
    @chat = current_user.chats.find(params[:id])

    return redirect_to chat_path(@chat) unless @chat.completed?

    @mistakes = @chat.quiz_mistakes
    @messages = @chat.conversation_messages
    @message = Message.new

    @score = @chat.score
    @total = @chat.quiz_questions.count
  end

  QUESTIONS_COUNT = 5

  def recap
    @chat = current_user ? current_user.chats.find(params[:id]) : guest_chat

    return redirect_to chat_path(@chat) unless @chat.completed?

    @score = @chat.score
    @total = @chat.quiz_questions.count

    @correct_answers = @chat.correct_answers
    @incorrect_answers = @chat.incorrect_answers

    @strengths = @correct_answers.includes(:question).map do |answer|
      answer.question.topic
    end.uniq

    @weaknesses = @incorrect_answers.includes(:question).map do |answer|
      answer.question.topic
    end.uniq

    @strengths -= @weaknesses

    @mistakes = @chat.quiz_mistakes
    @messages = @chat.conversation_messages
  end

  def generate_questions(category)
    prompt = <<~PROMPT
      Génère exactement #{QUESTIONS_COUNT} questions
      sur le thème : #{category.name}.

      Les questions doivent être des QCM en français.

      Chaque question doit contenir :
      - Une question
      - Quatre propositions différentes
      - Une seule bonne réponse
      - Une explication de la bonne réponse
      - La notion évaluée

      La difficulté doit être progressive.
      Varie la position de la bonne réponse.

      Réponds uniquement avec un tableau JSON
      respectant ce format :

      [
      {
          "question": "Quel mot-clé définit une méthode ?",
          "choices": ["class", "def", "function", "method"],
          "correct_option": 1,
          "feedback": "def permet de définir une méthode.",
          "topic": "Méthodes"
      }
      ]

      correct_option doit être un entier entre 0 et 3.
      Ne retourne aucun texte supplémentaire.
      Ne retourne aucune balise markdown.
    PROMPT

    llm = RubyLLM.chat

    llm.with_instructions(category.system_prompt) if category.system_prompt.present?

    response = llm.ask(prompt)

    response.content
  end

  def parse_questions(text)
    cleaned = text.to_s.gsub(/```(?:json)?/, "").strip

    questions = JSON.parse(cleaned)

    return [] unless questions.is_a?(Array)

    questions
  rescue JSON::ParserError
    []
  end

  private

  def valid_question?(question)
    return false unless question.is_a?(Hash)

    choices = question["choices"]
    correct_option = question["correct_option"]

    return false unless question["question"].is_a?(String)
    return false if question["question"].blank?

    return false unless choices.is_a?(Array)
    return false unless choices.count == 4

    return false unless choices.all? do |choice|
      choice.is_a?(String) && choice.present?
    end

    return false unless choices.map { |choice| choice.strip.downcase }.uniq.count == 4

    return false unless correct_option.is_a?(Integer)
    return false unless correct_option.between?(0, 3)

    return false unless question["feedback"].is_a?(String)
    return false if question["feedback"].blank?

    return false unless question["topic"].is_a?(String)
    return false if question["topic"].blank?

    true
  end

  def generate_quiz_questions(category)
    3.times do
      response = generate_questions(category)
      questions = parse_questions(response)

      if questions.count == QUESTIONS_COUNT &&
         questions.all? { |question| valid_question?(question) }

        return questions
      end
    end
    []
  end
end
