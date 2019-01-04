class PointsController < ApplicationController
  def new

  end
  def create
    #to_save = ActiveSupport::JSON.decode(params[:pts])
    #table_len =  to_save.length
    
    session_attachment_id = ActiveSupport::JSON.decode(params[:sessionAttachmentId]);
    session_attachment = SessionAttachment.find(session_attachment_id);
    session = session_attachment.session
    session.points_counter += 1
    session.update_attributes(points_counter: session.points_counter)

    point = Point.new
    point.x = params[:scale_x]
    point.y = params[:scale_y]
    point.session_attachment_id = session_attachment_id
    point.save
  end

  def remove
    point = Point.find(params[:point_id])
    point.destroy
    render head: :ok
  end

  def find_mark
    if(Mark.where(user_id: current_user.id, point_id: params[:current_point]).exists?)
      puts "istnieje "
      mark = Mark.where(user_id: current_user.id, point_id: params[:current_point]).first
      res = mark.description
      render json: {res: res,found: 1}
    else
      render json: {found: 0}
    end
  end 

end
