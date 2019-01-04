class PhotoSessionsController < ApplicationController
  before_action :find_session , only: [:show,:edit,:update,:destroy]
  before_filter :authenticate_user!

  def index
    @sessions = current_user.sessions.all 
  end

  def generate_txt 
    session = Session.find(params[:session_id])
    session_attachments = session.session_attachments.all 
    user = User.find(params[:user_id])

    i = 1

    text = ""
    session_attachments.each do |s|
      text << ("Picture " + i.to_s + ". ")
      i += 1 
      session_points = s.points
      j = 1
      session_points.each do |p|
        text << ("\n")
        text << (j.to_s + ": ")
        text << ("x: " + (s.image_width*p.x).round().to_s )
        text << (", y: " + (s.image_height*p.y).round().to_s )

        j+=1
        mark = p.marks.where(user_id: user.id).first
        text << (" Choosen option: " + mark.description )
      end 
      text << ("\n")       
    end

    send_data text, :filename => "sesja_#{session.token}_#{user.email}.txt"
  end 
  
  def show
    @session_attachments = @session.session_attachments.all
    @session_statuses = SessionStatus.where(session_id: @session.id)
    
  end

  def session_assessment 
    @session = Session.find(params[:session_id])
    @session_attachments = @session.session_attachments.all
  end
  
  def session_description
    @session = if params[:token].present?
      Session.where(token: params[:token]).first
    else
      nil
    end

    if @session
      @session_status = @session.session_statuses.where(user_id: current_user.id).first
    else
      flash[:error_information] = "Session with this token doesn't exist"
      redirect_to root_path
    end
  end

  def new
    @session = current_user.sessions.new
  end

  def create
    @session = current_user.sessions.new(session_params)

    token = SecureRandom.hex
    
    @session.token = token
    @session.points_counter = 0
    @session.is_uploaded = false
    if @session.save
      create_single_point if @session.single_point
      redirect_to photo_session_path(@session)
    else
      render 'new'
    end
  end

  def upload_session
    session = Session.find(params[:session_id])
    session.update_attributes(is_uploaded: true)
  end

  def search_session

    to_find = params[:token]
    @session = Session.where(token: to_find)[1]
    #@session_attachments = @session.session_attachments.all
    
    redirect_to photo_sessions_session_description_path(@session)
  end

  def edit
  end 

  def update
    if @session.update(session_params)
      create_single_point if @session.single_point
      redirect_to photo_session_path(@session)
    else
      render 'edit'
    end
  end

  def destroy
    @session.destroy
      redirect_to root_path
  end


  private 

  def find_session
    @session = Session.where(token: params[:id]).first
    raise ActiveRecord::RecordNotFound unless @session
  end
  
  def session_params
    if params[:session] && params[:new_attachments].present?
      if params[:session][:session_attachments_attributes]
        params[:session][:session_attachments_attributes] = params[:session][:session_attachments_attributes].values
      else
        params[:session][:session_attachments_attributes] = []
      end

      params[:new_attachments].each do |image|
        params[:session][:session_attachments_attributes] << { image: image }
      end
    end

    params.require(:session).permit(:title,:description,:single_point,session_attachments_attributes: [:id, :image, :_destroy])
  end

  def create_single_point
    points_counter = 0
    
    @session.session_attachments.all.each do |attachment|
      attachment.points.destroy_all
      
      point = attachment.points.new
      point.x = 0.5
      point.y = 0.5
      point.save
      
      points_counter += 1
    end
    @session.update_columns(points_counter: points_counter)
  end
end
