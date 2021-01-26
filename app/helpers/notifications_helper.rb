module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_note = link_to 'あなたの投稿', note_path(notification), style: 'font-weight: bold;'
    @visiter_comment = notification.comment_id
    # notification.actionがfollowかlikeかcommentか
    case notification.action
    when 'follow'
      tag.a(notification.visiter.nickname, href: user_path(@visiter), style: 'font-weight: bold;') + 'さんがあなたをフォローしました'
    when 'favorite'
      tag.a(notification.visiter.nickname, href: user_path(@visiter),
                                           style: 'font-weight: bold;') + 'さんが' + tag.a('あなたの投稿', href: note_path(notification.note_id),
                                                                                                  style: 'font-weight: bold;') + 'にいいねしました'
    when 'comment'
      @comment = Comment.find_by(id: @visiter_comment)&.text
      tag.a(@visiter.nickname, href: user_path(@visiter),
                               style: 'font-weight: bold;') + 'さんが' + tag.a('あなたの投稿', href: note_path(notification.note_id),
                                                                                      style: 'font-weight: bold;') + 'にコメントしました'
    end
  end
end
