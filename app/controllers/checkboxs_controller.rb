class CheckboxsController < ApplicationController
  def create
    puts params[:checkboxes]
    session_id = params[:sessionId]
    to_save = params[:checkboxes]
    to_save.each do |c|
      checkbox = Checkbox.new
      checkbox.description = c
      checkbox.session_id = session_id
      checkbox.save
    end

  end 
end
