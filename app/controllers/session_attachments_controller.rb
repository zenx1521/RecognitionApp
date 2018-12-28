class SessionAttachmentsController < ApplicationController
  before_action :set_session_attachment, only: [:show, :edit, :update, :destroy]

  # GET /session_attachments
  # GET /session_attachments.json
  def index
    @session_attachments = SessionAttachment.all
  end

  # GET /session_attachments/1
  # GET /session_attachments/1.json
  def show
  end

  # GET /session_attachments/new
  def new
    @session_attachment = SessionAttachment.new
  end

  # GET /session_attachments/1/edit
  def edit
  end

  # POST /session_attachments
  # POST /session_attachments.json
  def create
    @session_attachment = SessionAttachment.new(session_attachment_params)

    respond_to do |format|
      if @session_attachment.save
        format.html { redirect_to @session_attachment, notice: 'Session attachment was successfully created.' }
        format.json { render :show, status: :created, location: @session_attachment }
      else
        format.html { render :new }
        format.json { render json: @session_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /session_attachments/1
  # PATCH/PUT /session_attachments/1.json
  def update
    respond_to do |format|
      if @session_attachment.update(session_attachment_params)
        format.html { redirect_to @session_attachment, notice: 'Session attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @session_attachment }
      else
        format.html { render :edit }
        format.json { render json: @session_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /session_attachments/1
  # DELETE /session_attachments/1.json
  def destroy
    @session_attachment.destroy
    respond_to do |format|
      format.html { redirect_to session_attachments_url, notice: 'Session attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session_attachment
      @session_attachment = current_user.session_attachments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_attachment_params
      params.require(:session_attachment).permit(:session_id, :image)
    end
end
