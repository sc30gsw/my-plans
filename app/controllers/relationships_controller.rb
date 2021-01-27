class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]
  before_action :follow_user, only: %i[followings followers]
  before_action :paginate, only: %i[followings followers]

  def create
    following = current_user.follow(@user)
    if following.save
      redirect_to user_path(@user.id)
    else
      redirect_to user_path(@user.id)
    end
    # フォロー通知作成
    @user.create_notification_follow!(current_user)
  end

  def destroy
    following = current_user.unfollow(@user)
    if following.destroy
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
      redirect_to user_path(@user.id)
    end
  end

  def followings
    @users = @user.followings.all.page(params[:page]).per(10)
  end

  def followers
    @users = @user.followers.all.page(params[:page]).per(10)
  end

  private

  def set_user
    @user = User.find(params[:follow_id])
  end

  def follow_user
    @user = User.find(params[:id])
  end

  def paginate
    @notes = @user.note.page(params[:page]).per(5)
  end
end
