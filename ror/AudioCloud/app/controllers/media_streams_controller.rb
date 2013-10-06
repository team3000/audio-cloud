class MediaStreamsController < ApplicationController
  before_action :set_media_stream, only: [:show, :edit, :update, :destroy]

  # GET /media_streams
  # GET /media_streams.json
  def index
    @media_streams = MediaStream.all

  end

  # GET /media_streams/1
  # GET /media_streams/1.json
  def show
  end

  # GET /media_streams/new
  def new
    @media_stream = MediaStream.new
  end

  # GET /media_streams/1/edit
  def edit
  end

  # POST /media_streams
  # POST /media_streams.json
  def create
    @media_stream = MediaStream.new(media_stream_params)

    respond_to do |format|
      if @media_stream.save
        format.html { redirect_to @media_stream, notice: 'Media stream was successfully created.' }
        format.json { render action: 'show', status: :created, location: @media_stream }
      else
        format.html { render action: 'new' }
        format.json { render json: @media_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media_streams/1
  # PATCH/PUT /media_streams/1.json
  def update
    respond_to do |format|
      if @media_stream.update(media_stream_params)
        format.html { redirect_to @media_stream, notice: 'Media stream was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @media_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media_streams/1
  # DELETE /media_streams/1.json
  def destroy
    @media_stream.destroy
    respond_to do |format|
      format.html { redirect_to media_streams_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media_stream
      @media_stream = MediaStream.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_stream_params
      params.require(:media_stream).permit(:name, :detail, :permalink_url, :url, :download_url, :image_url, :media_type, :duration, :likes)
    end
end
