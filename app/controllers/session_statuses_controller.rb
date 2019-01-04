class SessionStatusesController < ApplicationController
  def create 
    if((SessionStatus.where(user_id: params[:user_id], session_id: params[:session_id] ).exists?))
      puts "oki"
    else
      session_status = SessionStatus.new
      session_status.user_id = params[:user_id]
      session_status.session_id = params[:session_id]
      session_status.finished = false
      session_status.marked_counter = 0
      session_status.save

    end
  end

  def finish_session 
    session_status = SessionStatus.where(user_id: params[:user_id], session_id: params[:session_id]).first
    session = session_status.session
    if(session_status.marked_counter == session.points_counter)
      session_status.update_attributes(:finished => true)
      redirect_to root_path
    else
      render json: {errored: "You didn't mark all points"}
    end
  end
end
