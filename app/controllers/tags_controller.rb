class TagsController < ApplicationController
  def note
    @tag = Tag.find(params[:id])
    @notes = @tag.notes.page(params[:page]).per(10)
  end
end
