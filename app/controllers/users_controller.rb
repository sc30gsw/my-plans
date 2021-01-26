class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]

  def show
    @notes = @user.note.page(params[:page]).per(4)

    # ユーザーnalytics
    @status_notes = @user.note.where(created_at: 6.days.ago.beginning_of_day..Time.zone.now.end_of_day)
    @all_count = @status_notes.count
    @favorited_notes = @user.favorited_notes.where(created_at: 6.days.ago.beginning_of_day..Time.zone.now.end_of_day)
    @commented_notes = @user.commented_notes.where(created_at: 6.days.ago.beginning_of_day..Time.zone.now.end_of_day)

    # DM機能
    
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
