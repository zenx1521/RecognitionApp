class MarksController < ApplicationController
  def createOrUpdate
    if(Mark.where(user_id: current_user.id, point_id: params[:currentActive] ).exists?)
      to_change = Mark.where(user_id: current_user.id, point_id: params[:currentActive]).first
      to_change.update_attributes(description: params[:choosenValue])
    else
      currentPoint = Point.find(params[:currentActive])
      mark = currentPoint.marks.build
      mark.user_id = current_user.id
      mark.point_id = params[:currentActive]
      mark.description = params[:choosenValue]
      mark.save
      session_status = SessionStatus.where(user_id: current_user.id, session_id: params[:session_id]).first
      session_status.update_attributes(marked_counter: session_status.marked_counter + 1)

    end

  end
  def find_unmarked
    session = Session.find(params[:session_id]);
    session.session_attachments.all.each do |attachment|
      attachment.points.all.each do |point|
        if(!(Mark.where(user_id: current_user.id,point_id: point.id ).exists?))
          render json: {pointId: point.id, attachmentId: attachment.id}
          return
        end
      end
    end 
    render json: {response: "All point's were marked"}   
  end
end
