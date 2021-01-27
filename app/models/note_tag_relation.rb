class NoteTagRelation
  include ActiveModel::Model
  attr_accessor :title, :text, :plan, :name, :image, :user_id

  with_options presence: true do
    validates :title
    validates :text
    validates :plan
  end

  def save
    note = Note.create(title: title, text: text, plan: plan, image: image, user_id: user_id)
    tag = Tag.where(name: name).first_or_initialize
    tag.save

    NoteTag.create(note_id: note.id, tag_id: tag.id)
  end
end
