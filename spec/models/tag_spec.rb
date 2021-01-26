require 'rails_helper'

RSpec.describe Tag, type: :model do
  before do
    @tag = FactoryBot.build(:tag)
  end

  context 'タグの投稿ができるとき' do
    it 'nameが存在すれば保存できる' do
      expect(@tag).to be_valid
    end

    it 'nameが空でも保存できる' do
      @tag.name = nil
      expect(@tag).to be_valid
    end
  end

  context 'タグの投稿ができないとき' do
    it 'nameが重複していると登録できない' do
      @tag.save
      another_tag = FactoryBot.build(:tag)
      another_tag.name = @tag.name
      another_tag.valid?
      expect(another_tag.errors.full_messages).to include('Nameはすでに存在します')
    end
  end
end
