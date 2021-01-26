require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @note = FactoryBot.create(:note)
    @comment = FactoryBot.build(:comment)
  end

  context 'コメント投稿がうまくいくとき' do
    it 'ログインしたユーザーはnote詳細ページでコメント投稿できる' do
      # ログインする
      sign_in(@note.user)
      # note詳細ページに遷移する
      visit note_path(@note)
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('comment[image]', image_path, make_visible: true)
      # フォームに情報を入力する
      fill_in 'comment_text', with: @comment.text
      # コメントを送信するとCommentモデルのカウントが1上がることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Comment.count }.by(1)
      # 詳細ページにリダイレクトされることを確認する
      expect(current_path).to eq note_path(@note)
      # 詳細ページには先ほどのコメント内容が含まれていることを確認する
      expect(page).to have_content(@comment.text)
      expect(page).to have_selector('img')
    end
  end

  context 'コメント投稿がうまくいかないとき' do
    it 'ログインしていないユーザーはnote詳細ページにいくことができない' do
      # トップページにいる
      visit root_path
      # トップページにはnote詳細ページへのリンクがない
      expect(page).to have_no_link(note_path(@note))
    end
  end
end
