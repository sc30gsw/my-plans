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
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @userEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
