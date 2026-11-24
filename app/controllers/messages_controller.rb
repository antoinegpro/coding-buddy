class MessagesController < ApplicationController
    SYSTEM_PROMPT = <<~PROMPT
    "You are a Teaching Assistant.
    
    I am a student at the Le Wagon AI Software Development Bootcamp, learning how to code.
    
    Help me break down my problem into small, actionable steps, without giving away solutions.
    
    Answer concisely in Markdown."
    PROMPT
    
    def create
        @chat = current_user.chats.find(params[:chat_id])
        @category = @chat.category

        @message = Message.new(message_params)
        @message.chat = @chat
        @message.role = "user"

        if @message.save
        ruby_llm_chat = RubyLLM.chat
        response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
        Message.create(role: "assistant", content: response.content, chat: @chat)

        redirect_to chats_path(@chat)
        else
        render "chats/show", status: :unprocessable_entity
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end

end
