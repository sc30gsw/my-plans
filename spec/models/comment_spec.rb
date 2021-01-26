require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント新規投稿' do
    context 'コメント投稿がうまくいくとき' do
      it 'textが存在すれば投稿できる' do
        @comment.image = nil
        expect(@comment).to be_valid
      end

      it 'imageが存在すれば投稿できる' do
        @comment.text = nil
        expect(@comment).to be_valid
      end

      it 'すべての項目が存在すれば投稿できる' do
        expect(@comment).to be_valid
      end
    end

    context 'コメント投稿がうまくいかないとき' do
      it 'textとimageの両方が空だと投稿できない' do
        @comment.text = nil
        @comment.image = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Textを入力してください')
      end
    end
  end
end
