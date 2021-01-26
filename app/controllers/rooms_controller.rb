class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show destroy]

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if @room.destroy
      redirect_to root_path
    else
      render action: :show
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end
end
