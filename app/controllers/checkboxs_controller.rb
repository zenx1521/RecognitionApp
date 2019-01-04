class CheckboxsController < ApplicationController
  def create
    puts params[:checkboxes]
    session_id = params[:session_id]
    text = params[:checkbox_text]
    checkbox = Checkbox.new
    checkbox.description = text
    checkbox.session_id = session_id
    checkbox.save
  end 

  def remove
    session = Session.find(params[:session_id])
    session.checkboxs.where(description: params[:checkbox_text]).first.destroy
  end
end
