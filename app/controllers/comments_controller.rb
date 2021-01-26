class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def create
    @note = Note.find(params[:note_id])
    @comment = @note.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment_note = @comment.note

    # 通知の作成
    if @comment.valid?
      @comment.save
      @comment_note.create_notification_comment!(current_user, @comment.id)
      redirect_to note_path(@note.id)
    else
      render 'notes/show'
    end
  end

  def destroy
    @note = @comment.note
    if @comment.user_id == current_user.id
      @comment.destroy
      redirect_to note_path(@note.id)
    else
      render 'notes/show'
    end
  end

  def user
    @user = User.find(params[:id])
    @notes = @user.note.page(params[:page]).per(10)
    @comment_notes = @user.commented_notes.page(params[:page]).per(10)
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :image).merge(user_id: current_user.id, note_id: params[:note_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
