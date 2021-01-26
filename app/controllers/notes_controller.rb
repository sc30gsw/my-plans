class NotesController < ApplicationController
  before_action :authenticate_user!, except: %i[index order_index show search]
  before_action :set_note, only: %i[show edit update destroy favorite]

  def index
    @notes = Note.includes(:user).sort { |a, b| b.favorited_users.count <=> a.favorited_users.count }
    @notes = Kaminari.paginate_array(@notes).page(params[:page]).per(6)
  end

  def order_index
    @notes = Note.includes(:user).page(params[:page]).per(6).order('created_at DESC')
  end

  def new
    @note = NoteTagRelation.new
  end

  def create
    @note = NoteTagRelation.new(note_tag_params)
    if @note.valid?
      @note.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @note.comments.includes(:user).order('created_at DESC')
  end

  def edit
    redirect_to note_path(@note.id) unless @note.user_id == current_user.id
  end

  def update
    if @note.update(note_params)
      redirect_to note_path(@note.id)
    else
      render :edit
    end
  end

  def destroy
    if current_user.id == @note.user_id
      @note.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  def favorite
  end

  def search
    return nil if params[:keyword] == ''

    tag = Tag.where(['name LIKE ?', "%#{params[:keyword]}%"])
    render json: { keyword: tag }
  end

  def note_search
    @notes = Note.search(params[:keyword])
    @notes = @notes.page(params[:page]).per(10)
  end

  private

  def note_tag_params
    params.require(:note_tag_relation).permit(:title, :text, :plan, :image, :name).merge(user_id: current_user.id)
  end

  def note_params
    params.require(:note).permit(:title, :text, :plan, :image).merge(user_id: current_user.id)
  end

  def set_note
    @note = Note.find(params[:id])
  end
end
