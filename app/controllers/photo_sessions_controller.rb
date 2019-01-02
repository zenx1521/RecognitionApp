class PhotoSessionsController < ApplicationController
  before_action :find_session , only: [:show,:edit,:update,:destroy]
  before_filter :authenticate_user!

  def index
    @sessions = current_user.sessions.all 
    #@sessions = Session.all
  end

  def generate_txt 
    session = Session.find(params[:session_id])
    session_attachments = session.session_attachments.all 
    puts params[:user_id]
    i = 1
    path = "/home/jduraj/Dokumenty/new.txt"
    File.open(path, "w+") do |f|
      session_attachments.each do |s|
        f.write(i.to_s + ": ")
        i += 1 
        session_points = s.points
        j = 1
        session_points.each do |p|
          f.write(j.to_s + ":")
          j+=1
          mark = p.marks.where(user_id: params[:user_id]).first
          f.write(mark.description + " ")
        end 
        f.write("\n")       
      end
    end

    session_attachments.each do |s|
      session_points = s.points
      session_points.each do |p|
        mark = p.marks.where(user_id: params[:user_id]).first
        puts mark.description
      end
    end
  end 
  def show
    @session_attachments = @session.session_attachments.all
    @session_statuses = SessionStatus.where(session_id: @session.id)

    #path = "/home/jduraj/Dokumenty/new.txt"
    #content = "data from the form"
    #File.open(path, "w+") do |f|
    #  f.write(content)
    #end
    
    
  end
  def session_assessment 
    @session = Session.find(params[:session_id])
    @session_attachments = @session.session_attachments.all
  end
  def session_description 
    if(Session.where(token: params[:token]).exists?)
      to_find = params[:token]
      @session = Session.where(token: to_find)[0]
    else
      flash[:error_information] = "Session with this token doesn't exist"
      redirect_to root_path
    end
  end

  def new
    @session = current_user.sessions.new
    @session_attachment = @session.session_attachments.build
  end

  def create
    @session = current_user.sessions.new(session_params)
    token = SecureRandom.hex
    @session.token = token
    @session.points_counter = 0
    @session.is_uploaded = false
    if !params[:session_attachments].nil?
      if @session.save
        params[:session_attachments]['image'].each do |attachment|
          @session_attachment = @session.session_attachments.create!(:image => attachment)
        end
        if(@session.single_point)
          @session.session_attachments.all.each do |attachment|
            point = attachment.points.new
            point.x = 0.5
            point.y = 0.5
            point.save
            @session.points_counter += 1          
          end
          @session.update_attributes(points_counter: @session.points_counter)
        end
        redirect_to photo_session_path(@session)
      else
        render 'new'
      end
    else
      @session_attachment = @session.session_attachments.build    
      @session.errors.add(:session_attachments,"Add at least one image")
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
    params.require(:session).permit(:title,:description,:single_point,session_attachments_attributes: [:id, :session_id, :image])
  end
end
