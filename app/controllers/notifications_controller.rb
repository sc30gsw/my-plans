class NotificationsController < ApplicationController
  def index
    # current_userの投稿に紐付いた通知一覧
    @notifications = current_user.passive_notifications.order(created_at: :DESC)
    # @notificationの中でまだ確認していな通知のみ
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy
    # 通知を全削除
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to root_path
  end
end
