class FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @favorite = current_user.favorites.new(note_id: params[:note_id])
    @favorite.save
    @note = Note.find(params[:note_id])
    # 通知作成
    @note.create_notification_by(current_user)
    redirect_to "/notes/#{params[:note_id]}" if @favorite.save
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, note_id: params[:note_id])
    redirect_to "/notes/#{params[:note_id]}" if @favorite.destroy
  end

  def user
    @user = User.find(params[:id])
    @notes = @user.note.page(params[:page]).per(10)
    @favorite_notes = @user.favorited_notes.page(params[:page]).per(10)
  end
end
