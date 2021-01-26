require 'rails_helper'

RSpec.describe 'intro新規登録', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @intro = FactoryBot.build(:intro)
  end

  context '新規登録ができるとき' do
    it '新規登録したユーザーはプロフィールの新規登録ができる' do
      # ログインする
      sign_in(@user)
      # ユーザー詳細に遷移するアイコンがある
      expect(page).to have_selector '.index-icon'
      # ユーザー詳細に遷移する
      visit user_path(@user.id)
      # ドロップダウンメニューがあることを確認する
      expect(page).to have_selector '.nav-link'
      # ドロップダウンメニューをクリックする
      find('.nav-link').click
      # ドロップダウンメニューに「プロフィールを編集する」があること確認する
      expect(page).to have_content('プロフィールを編集する')
      # プロフィール新規登録ページに移動する
      visit new_intro_path
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # ユーザー情報を入力する
      fill_in 'firstname', with: @intro.first_name
      fill_in 'lastname', with: @intro.last_name
      fill_in 'website', with: @intro.website
      fill_in 'profile', with: @intro.profile
      # 画像選択フォームに画像を添付する
      attach_file('intro[image]', image_path, make_visible: true)
      # 送信するとIntroモデルのカウントが1上がる
      expect do
        find('input[name="commit"]').click
      end.to change { Intro.count }.by(1)
      # 詳細ページに遷移することを確認する
      expect(current_path).to eq user_path(@user.id)
      # 詳細ページには先ほど入力した内容のプロフィールが存在することを確認する(画像)
      expect(page).to have_selector '.index-icon'
      # 詳細ページには先ほど入力した内容のプロフィールが存在することを確認する(テキスト)
      expect(page).to have_content @intro.first_name
      expect(page).to have_content @intro.last_name
      expect(page).to have_content @intro.website
      expect(page).to have_content @intro.profile
    end
  end

  context '新規登録ができないとき' do
    it 'ログインしていないと新規登録できない' do
      # トップページに遷移する
      visit root_path
      # ユーザー詳細に遷移するアイコンがない
      expect(page).to have_no_selector '.index-icon'
    end
  end
end

RSpec.describe 'プロフィール編集', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @intro1 = FactoryBot.create(:intro)
    @intro2 = FactoryBot.create(:intro)
  end

  context 'プロフィール編集ができるとき' do
    it 'ログインしたユーザーは自分のプロフィールを編集できる' do
      # @user1でユーザーでログインする
      sign_in(@user1)
      # ユーザー詳細に遷移するアイコンがある
      expect(page).to have_selector '.index-icon'
      # @user1の詳細ページへ遷移する
      visit user_path(@user1.id)
      # ドロップダウンメニューがあることを確認する
      expect(page).to have_selector '.nav-link'
      # ドロップダウンメニューをクリックする
      find('.nav-link').click
      # ドロップダウンメニューに「プロフィールを編集する」があること確認する
      expect(page).to have_content('プロフィールを編集する')
      # プロフィール新規登録ページに移動する
      visit new_intro_path
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # ユーザー情報を入力する
      fill_in 'firstname', with: @intro1.first_name
      fill_in 'lastname', with: @intro1.last_name
      fill_in 'website', with: @intro1.website
      fill_in 'profile', with: @intro1.profile
      # 画像選択フォームに画像を添付する
      attach_file('intro[image]', image_path, make_visible: true)
      # 送信するとIntroモデルのカウントが1上がる
      expect do
        find('input[name="commit"]').click
      end.to change { Intro.count }.by(1)
      # 詳細ページに遷移することを確認する
      expect(current_path).to eq user_path(@user1.id)
      # 詳細ページには先ほど入力した内容のプロフィールが存在することを確認する(画像)
      expect(page).to have_selector '.index-icon'
      # 詳細ページには先ほど入力した内容のプロフィールが存在することを確認する(テキスト)
      expect(page).to have_content @intro1.first_name
      expect(page).to have_content @intro1.last_name
      expect(page).to have_content @intro1.website
      expect(page).to have_content @intro1.profile
      # @user1の詳細ページへ遷移することをする
      expect(current_path).to eq user_path(@user1.id)
      # ドロップダウンメニューがあることを確認する
      expect(page).to have_selector '.nav-link'
      # ドロップダウンメニューをクリックする
      find('.nav-link').click
      # ドロップダウンメニューに「プロフィールを編集する」があること確認する
      expect(page).to have_content('プロフィールを編集する')
      # プロフィール編集ページのリンクをクリックする
      find('.profile-edit').click
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(find('.first_name').value).to eq @intro1.first_name
      expect(find('.last_name').value).to eq @intro1.last_name
      expect(find('.website').value).to eq @intro1.website
      expect(find('.profile').value).to eq @intro1.profile
      # 添付する画像2を定義する
      image_path2 = Rails.root.join('public/images/test_image2.png')
      # 登録内容を編集する
      fill_in 'firstname', with: "#{@intro1.first_name}test"
      fill_in 'lastname', with: "#{@intro1.last_name}test"
      fill_in 'website', with: "#{@intro1.website}test"
      fill_in 'profile', with: "#{@intro1.profile}test"
      # 画像選択フォーム画像を添付する
      attach_file('intro[image]', image_path2, make_visible: true)
      # 送信してもIntroモデルのカウントが変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Intro.count }.by(0)
      # @user1詳細ページに遷移することを確認する
      expect(current_path).to eq user_path(@user1.id)
      # 詳細ページには先ほど入力した内容のプロフィールが存在することを確認する(画像)
      expect(page).to have_selector '.index-icon'
      # 詳細ページには先ほど入力した内容のプロフィールが存在することを確認する(テキスト)
      expect(page).to have_content @intro1.first_name
      expect(page).to have_content @intro1.last_name
      expect(page).to have_content @intro1.website
      expect(page).to have_content @intro1.profile
    end
  end

  context 'ユーザー編集ができないとき' do
    it 'ログインしたユーザーは自分以外が登録したプロフィールを編集できない' do
      # トップページへ遷移する
      visit root_path
      # user1でログインする
      sign_in(@user1)
      # user2の詳細ページに遷移する
      visit user_path(@user2.id)
      # ドロップダウンメニューがあることを確認する
      expect(page).to have_selector '.nav-link'
      # ドロップダウンメニューをクリックする
      find('.nav-link').click
      # ドロップダウンメニューに「プロフィールを編集する」がないこと確認する
      expect(page).to have_no_content('プロフィールを編集する')
    end

    it 'ログインしていないと@intor1の編集画面へ遷移できない' do
      # トップページへ遷移する
      visit root_path
      # user1の詳細ページに遷移できない
      expect(page).to have_no_link(user_path(@user1.id))
    end

    it 'ログインしていないと@intro2の編集画面へ遷移できない' do
      # トップページへ遷移する
      visit root_path
      # user2の詳細ページに遷移できないことを確認する
      expect(page).to have_no_link(user_path(@user2.id))
    end
  end
end
