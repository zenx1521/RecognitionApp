class PointsController < ApplicationController
  def new

  end
  def create
    to_save = ActiveSupport::JSON.decode(params[:pts])
    table_len =  to_save.length
    
    session_attachment_id = ActiveSupport::JSON.decode(params[:sessionAttachmentId]);
    session_attachment = SessionAttachment.find(session_attachment_id);
    session = session_attachment.session
    session.points_counter += table_len
    session.update_attributes(points_counter: session.points_counter)



    to_save.each do |s|
      point = Point.new
      point.x = s[0]
      point.y = s[1]
      point.session_attachment_id = session_attachment_id
      point.save
    end
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
