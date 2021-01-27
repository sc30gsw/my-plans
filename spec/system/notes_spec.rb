require 'rails_helper'

RSpec.describe '新規投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @note = FactoryBot.build(:note)
  end

  context 'note投稿ができるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('投稿する')
      # 投稿ページに移動する
      visit new_note_path
      # フォームに情報を入力する
      fill_in 'note_tag_relation_title', with: @note.title
      fill_in 'note_tag_relation_text', with: @note.text
      fill_in 'note_tag_relation_plan', with: @note.plan
      # 画像選択フォームに画像を添付する
      attach_file 'note_tag_relation_image', 'public/images/test_image.png'
      # 送信するとNoteモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Note.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # トップページには先ほど投稿した内容のnoteがあることを確認する
      expect(page).to have_content(@note.title)
    end
  end

  context 'note投稿ができないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがない
      expect(page).to have_no_content('投稿する')
    end
  end
end

RSpec.describe '投稿詳細', type: :system do
  before do
    @note = FactoryBot.create(:note)
    @user = FactoryBot.create(:user)
  end
  it 'ログインしたユーザーはnote詳細ページに遷移してコメント投稿欄が表示される' do
    # ログインする
    sign_in(@user)
    # 投稿のタイトルリンクがあることを確認する
    expect(page).to have_content(@note.title)
    # 詳細ページに遷移する
    visit note_path(@note)
    # 詳細ページに投稿内容が含まれている
    expect(page).to have_content(@note.title)
    expect(page).to have_content(@note.text)
    expect(page).to have_content(@note.plan)
    expect(page).to have_selector '.show-note-image'
    # コメント用フォームが存在する
    expect(page).to have_selector '.comment-textarea'
  end

  it 'ログインしていな状態ではnote詳細ページに遷移できない' do
    # トップページに移動する
    visit root_path
    # タイトルリンクをクリックする
    find('.note_show_links').click
    # クリックするとログイン画面に遷移する
    expect(current_path).to eq '/users/sign_in'
  end
end

RSpec.describe '投稿編集', type: :system do
  before do
    @note1 = FactoryBot.create(:note)
    @note2 = FactoryBot.create(:note)
  end

  context 'note編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したnoteを編集できる' do
      # note1を投稿したユーザーでログインする
      sign_in(@note1.user)
      # note1の投稿のタイトルリンクがあることを確認する
      expect(page).to have_content(@note1.title)
      # note1詳細ページに遷移する
      visit note_path(@note1)
      # note1にドロップダウンボタンがあることを確認する
      expect(page).to have_selector '.plan-drop'
      # note1のドロップダウンボタンをクリックする
      find('.plan-drop').click
      # 編集ページへ遷移する
      visit edit_note_path(@note1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(find('#note_title').value).to eq @note1.title
      expect(find('#note_text').value).to eq @note1.text
      expect(find('#note_plan').value).to eq @note1.plan
      # 投稿内容を編集する
      fill_in 'note_title', with: @note1.title
      fill_in 'note_text', with: @note1.text
      fill_in 'note_plan', with: @note1.plan
      # 画像選択フォームに画像を添付する
      attach_file 'note_image', 'public/images/test_image2.png'
      # 編集してもNoteモデルのカウントは変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Note.count }.by(0)
      # note1の詳細ページに遷移することを確認する
      expect(current_path).to eq note_path(@note1)
      # note1の詳細ページには先ほど編集した内容が存在することを確認する
      expect(page).to have_content(@note1.title)
      expect(page).to have_content(@note1.text)
      expect(page).to have_content(@note1.plan)
      expect(page).to have_selector('.show-note-image')
    end
  end

  context 'note編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # note1を投稿したユーザーでログインする
      sign_in(@note1.user)
      # note2の投稿のタイトルリンクがある
      expect(page).to have_content(@note2.title)
      # note2詳細ページに遷移する
      visit note_path(@note2)
      # note2にドロップダウンがないことを確認する
      expect(page).to have_no_selector('.plan-drop')
    end

    it 'ログインしていないとnote1編集画面には遷移できないこと' do
      # トップページいる
      visit root_path
      # note1にタイトルがあることを確認する
      expect(page).to have_content(@note1.title)
      # note1の詳細画面に遷移する
      visit note_path(@note1)
      # note1の詳細画面に遷移しようとするとログイン画面に遷移する
      expect(current_path).to eq '/users/sign_in'
    end

    it 'ログインしていないとnote2編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # note2にタイトルがあることを確認する
      expect(page).to have_content(@note2.title)
      # note2の詳細画面に遷移する
      visit note_path(@note2)
      # note2の詳細画面に遷移しようとするとログイン画面に遷移する
      expect(current_path).to eq '/users/sign_in'
    end
  end
end

RSpec.describe '投稿編集', type: :system do
  before do
    @note1 = FactoryBot.create(:note)
    @note2 = FactoryBot.create(:note)
  end

  context 'note削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したnoteを削除できる' do
      # note1を投稿したユーザーでログインする
      sign_in(@note1.user)
      # note1の投稿のタイトルリンクがあることを確認する
      expect(page).to have_content(@note1.title)
      # note1詳細ページに遷移する
      visit note_path(@note1)
      # note1にドロップダウンボタンがあることを確認する
      expect(page).to have_selector '.plan-drop'
      # note1のドロップダウンボタンをクリックする
      find('.plan-drop').click
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect do
        find_link('削除する', href: note_path(@note1)).click
      end.to change { Note.count }.by(-1)
      # トップページに遷移する
      visit root_path
    end
  end

  context 'note削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したnoteを削除できない' do
      # note1を投稿したユーザーでログインする
      sign_in(@note1.user)
      # note2の投稿のタイトルリンクがない
      expect(page).to have_content(@note2.title)
      # note2詳細ページに遷移する
      visit note_path(@note2)
      # note2にドロップダウンがないことを確認する
      expect(page).to have_no_selector('.plan-drop')
    end

    it 'ログインしていなとnote1の削除ボタンがない' do
      # トップページいる
      visit root_path
      # note1にタイトルリンクがないことを確認する
      expect(page).to have_no_link(note_path(@note1))
    end

    it 'ログインしていなとnote2の削除ボタンがない' do
      # トップページにいる
      visit root_path
      # note2にタイトルリンクがある
      expect(page).to have_no_link(note_path(@note2))
    end
  end
end
