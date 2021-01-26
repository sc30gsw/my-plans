require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録がうまくいくとき' do
      it 'すべての項目が存在すれば登録できる' do
        expect(@user).to be_valid
      end
    end
    context '新規登録がうまく行かないとき' do
      it 'nicknameが空だと登録できない' do
        @user.nickname = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('ユーザー名を入力してください')
      end

      it 'nicknameが3文字以下だと登録できない' do
        @user.nickname = 111
        @user.valid?
        expect(@user.errors.full_messages).to include('ユーザー名が4文字以上の半角英数字ではありません')
      end

      it 'nicknameが全角かな/カナ/漢字だと登録できない' do
        @user.nickname = 'あんアン龥'
        @user.valid?
        expect(@user.errors.full_messages).to include('ユーザー名が4文字以上の半角英数字ではありません')
      end

      it 'emialが空だと登録できない' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end

      it 'emailが重複していると登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end

      it 'emailに@を含んでいなければ登録できない' do
        @user.email = 'test.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end

      it 'passwordが空だと登録できない' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end

      it 'passwordが7文字以下だと登録できない' do
        @user.password = 1_111_111
        @user.password_confirmation = 1_111_111
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは8文字以上の半角英数字ではありません')
      end

      it 'passwordとpassword_confirmationが一致しないと登録できない' do
        @user.password = 11_111_111
        @user.password_confirmation = 22_222_222
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end

      it 'passwordが存在してもpassword_confirmationが存在しなければ登録できない' do
        @user.password = 11_111_111
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end

      it 'passwordが数字のみだと登録できない' do
        @user.password = 11_111_111
        @user.password_confirmation = 11_111_111
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは8文字以上の半角英数字ではありません')
      end
    end
  end
end
