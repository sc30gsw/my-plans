class IntrosController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit]
  before_action :set_intro, only: %i[edit update]

  def new
    @intro = Intro.new
    redirect_to root_path if Intro.find_by(user_id: current_user.id)
  end

  def create
    @intro = Intro.new(intro_params)
    if @intro.save
      redirect_to user_path(@intro.user.id)
    else
      render :new
    end
  end

  def edit
    redirect_to root_path unless current_user.id == @intro.user.id
  end

  def update
    if @intro.update(intro_params)
      redirect_to user_path(@intro.user.id)
    else
      render :edit
    end
  end

  private

  def set_intro
    @intro = Intro.find(params[:id])
  end

  def intro_params
    params.require(:intro).permit(:first_name, :last_name, :website, :profile, :image).merge(user_id: current_user.id)
  end
end
