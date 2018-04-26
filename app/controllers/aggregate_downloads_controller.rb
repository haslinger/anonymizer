class AggregateDownloadsController < ApplicationController
  before_action :set_aggregate_download, only: [:show, :edit, :update, :destroy]

  # GET /aggregate_downloads
  # GET /aggregate_downloads.json
  def index
    @aggregate_downloads = AggregateDownload.all.includes(:episode)
  end

  # GET /aggregate_downloads/1
  # GET /aggregate_downloads/1.json
  def show
  end

  # GET /aggregate_downloads/new
  def new
    @aggregate_download = AggregateDownload.new
  end

  # GET /aggregate_downloads/1/edit
  def edit
  end

  # POST /aggregate_downloads
  # POST /aggregate_downloads.json
  def create
    @aggregate_download = AggregateDownload.new(aggregate_download_params)

    respond_to do |format|
      if @aggregate_download.save
        format.html { redirect_to @aggregate_download, notice: 'Aggregate download was successfully created.' }
        format.json { render :show, status: :created, location: @aggregate_download }
      else
        format.html { render :new }
        format.json { render json: @aggregate_download.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aggregate_downloads/1
  # PATCH/PUT /aggregate_downloads/1.json
  def update
    respond_to do |format|
      if @aggregate_download.update(aggregate_download_params)
        format.html { redirect_to @aggregate_download, notice: 'Aggregate download was successfully updated.' }
        format.json { render :show, status: :ok, location: @aggregate_download }
      else
        format.html { render :edit }
        format.json { render json: @aggregate_download.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aggregate_downloads/1
  # DELETE /aggregate_downloads/1.json
  def destroy
    @aggregate_download.destroy
    respond_to do |format|
      format.html { redirect_to aggregate_downloads_url, notice: 'Aggregate download was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aggregate_download
      @aggregate_download = AggregateDownload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aggregate_download_params
      params.require(:aggregate_download).permit(:episode_id, :day, :volume, :hits, :count)
    end
end
