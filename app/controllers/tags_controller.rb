class TagsController < ApplicationController
  before_action :authenticate_user!
  def note
    @tag = Tag.find(params[:id])
    @notes = @tag.notes.page(params[:page]).per(10)
  end
end
