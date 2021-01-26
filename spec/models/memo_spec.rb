require 'rails_helper'

RSpec.describe Memo, type: :model do
  before do
    @memo = FactoryBot.build(:memo)
  end

  describe 'メモ投稿' do
    context 'メモ投稿がうまくいくとき' do
      it 'すべての項目が存在すれば保存できる' do
        expect(@memo).to be_valid
      end
    end

    context 'メモ投稿がうまくいかないとき' do
      it 'contentが存在しなければ保存できない' do
        @memo.content = nil
        @memo.valid?
        expect(@memo.errors.full_messages).to include('Contentを入力してください')
      end
    end
  end
end
