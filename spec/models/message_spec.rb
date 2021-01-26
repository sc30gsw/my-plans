require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @message = FactoryBot.build(:message)
  end

  describe 'メッセージ投稿' do
    context 'メッセージ投稿がうまくいかないとき' do
      it 'textが空だと投稿できない' do
        @message.text = nil
        @message.valid?
        expect(@message.errors.full_messages).to include('Textを入力してください')
      end

      it 'roomが空だと投稿できない' do
        @message.room_id = nil
        @message.valid?
        expect(@message.errors.full_messages).to include('Roomを入力してください')
      end
    end
  end
end
