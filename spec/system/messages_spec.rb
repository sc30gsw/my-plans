require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @message = FactoryBot.build(:message)
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、チャットルームに投稿した内容が表示される' do
      # @user1でサインインする
      sign_in(@user1)
      # @user2の詳細ページに遷移する
      visit user_path(@user2)
      # @user2の詳細ページにフォローボタンを確認する
      expect(page).to have_selector('.btn-follow')
      # @user2をフォローする
      find('.btn-follow').click
      # @user1の詳細ページに遷移する
      visit user_path(@user1)
      # ドロップダウンメニューをクリックする
      find('.nav-link').click
      # ログアウトする
      find('.logout-item').click
      # @user2でログインする
      sign_in(@user2)
      # @user1の詳細ページに遷移する
      visit user_path(@user1)
      # @user1の詳細ページにフォローボタンを確認する
      expect(page).to have_selector('.btn-follow')
      # @user1をフォローする
      find('.btn-follow').click
      # 「チャットを始める」ボタンを確認する
      expect(page).to have_selector('.user-show-chat')
      # 「チャットを始める」をクリックする
      find('.user-show-chat').click
      # チャットルームに遷移すると「チャットルーム」という文字があることを確認する
      expect(page).to have_content('チャットルーム')
      # 値をフォームに入力する
      fill_in 'message_text', with: @message.text
      # 送信するとMessageモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Message.count }.by(1)
      # 送信した値がブラウザに表示されることを確認する
      expect(page).to have_content(@message.text)
    end
  end

  context '投稿に失敗したとき' do
    it 'テキストの投稿に失敗すると、チャットルームにリダイレクトする' do
      # @user1でサインインする
      sign_in(@user1)
      # @user2の詳細ページに遷移する
      visit user_path(@user2)
      # @user2の詳細ページにフォローボタンを確認する
      expect(page).to have_selector('.btn-follow')
      # @user2をフォローする
      find('.btn-follow').click
      # @user1の詳細ページに遷移する
      visit user_path(@user1)
      # ドロップダウンメニューをクリックする
      find('.nav-link').click
      # ログアウトする
      find('.logout-item').click
      # @user2でログインする
      sign_in(@user2)
      # @user1の詳細ページに遷移する
      visit user_path(@user1)
      # @user1の詳細ページにフォローボタンを確認する
      expect(page).to have_selector('.btn-follow')
      # @user1をフォローする
      find('.btn-follow').click
      # 「チャットを始める」ボタンを確認する
      expect(page).to have_selector('.user-show-chat')
      # 「チャットを始める」をクリックする
      find('.user-show-chat').click
      # チャットルームに遷移すると「チャットルーム」という文字があることを確認する
      expect(page).to have_content('チャットルーム')
      # フォームを空で送信する
      fill_in 'message_text', with: ''
      # 送信してもMessageモデルのカウントが上がらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Message.count }.by(0)
      # チャットルームの文字があることを確認する
      expect(page).to have_content('チャットルーム')
    end
  end
end
