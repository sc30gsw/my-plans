require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @note = FactoryBot.build(:note)
  end

  describe '新規投稿' do
    context '新規投稿がうまくいくとき' do
      it 'すべての項目が存在すれば投稿できる' do
        expect(@note).to be_valid
      end

      it '画像が空でも保存できる' do
        @note.image = nil
        expect(@note).to be_valid
      end
    end

    context '新規投稿がうまくいかないとき' do
      it 'titleが空だと投稿できない' do
        @note.title = nil
        @note.valid?
        expect(@note.errors.full_messages).to include('Titleを入力してください')
      end

      it 'textが空だと投稿できない' do
        @note.text = nil
        @note.valid?
        expect(@note.errors.full_messages).to include('Textを入力してください')
      end

      it 'planが空だと投稿できない' do
        @note.plan = nil
        @note.valid?
        expect(@note.errors.full_messages).to include('Planを入力してください')
      end
    end
  end
end
