class ChatsController < ApplicationController
    def create
        @category = Category.find(params[:category_id])

        @chat = Chat.new(title: "Untitled")
        @chat.category = @category
        @chat.user = current_user

        if @chat.save
            redirect_to chat_path(@chat)
        else
            @chats = @category.chats.where(user: current_user)
            render "categories/show", status: unprocessable_entity
        end
    end

    def show
        @chat    = current_user.chats.find(params[:id])
        @message = Message.new
    end

    
end

