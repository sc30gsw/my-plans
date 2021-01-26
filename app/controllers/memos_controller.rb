class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[index destroy]

  def index
    @memos = Memo.all.order('created_at DESC')
    redirect_to root_path unless current_user.id == @user.id
  end

  def create
    @memo = Memo.new(memo_params)
    if @memo.valid?
      @memo.save
      redirect_to "/memos/user/#{current_user.id}"
    else
      render action: :index
    end
  end

  def destroy
    if current_user.id == @user.id
      Memo.destroy_all
      redirect_to "/memos/user/#{current_user.id}"
    else
      render action: :index
    end
  end

  def checked
    memo = Memo.find(params[:id])
    if memo.checked
      memo.update(checked: false)
    else
      memo.update(checked: true)
    end

    item = Memo.find(params[:id])
    render json: { memo: item }
  end

  private

  def memo_params
    params.permit(:content).merge(user_id: current_user.id)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
