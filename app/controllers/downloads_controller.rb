class DownloadsController < ApplicationController
  before_action :set_download, only: [:show, :edit, :update, :destroy]

  # GET /downloads
  # GET /downloads.json
  def index
    @downloads = Download.all
                         .order(:count)
                         .order("episodes.podcast")
                         .where(episodes: {podcast: "3-schweinehun.de"})
                         .includes(:episode)
  end


  def report
    @downloads = Download.joins(:episode)
                         .select(:name,
                                 "episodes.filesize AS filesize",
                                 "episodes.podcast AS podcast",
                                 "sum(volume) AS volume")
                         .where("episodes.number < 999")
                         .order("episodes.number")
                         .group("episodes.podcast", "episodes.number")
                         .group_by(&:podcast)
  end

  def trend
    @title = Podcast.find(params[:id]).name

    @downloads = Download.joins(episode: :podcast)
                         .select("episodes.name AS name",
                                 "episodes.filesize AS filesize",
                                 "episodes.podcast AS podcast",
                                 "sum(volume) AS volume")
                         .where("episodes.number < 999")
                         .where("podcasts.id = ?", params[:id])
                         .group("episodes.podcast", "episodes.number")
                         .order("episodes.number")

    @downloads_by_episode =
      Download.joins(episode: :podcast)
              .select(:day,
                      "episodes.name AS name",
                      "episodes.number AS number",
                      "episodes.filesize AS filesize",
                      "sum(volume) AS volume")
              .where("podcasts.id = ?", params[:id])
              .where("number < 999")
              .group(:number, :day)
              .group_by(&:number)

   @episodes = Episode.joins(:podcast).where("podcasts.id = ?", params[:id])
  end


  # GET /downloads/1
  # GET /downloads/1.json
  def show
  end

  # GET /downloads/new
  def new
    @download = Download.new
  end

  # GET /downloads/1/edit
  def edit
  end

  # POST /downloads
  # POST /downloads.json
  def create
    @download = Download.new(download_params)

    respond_to do |format|
      if @download.save
        format.html { redirect_to @download, notice: 'Aggregate download was successfully created.' }
        format.json { render :show, status: :created, location: @download }
      else
        format.html { render :new }
        format.json { render json: @download.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /downloads/1
  # PATCH/PUT /downloads/1.json
  def update
    respond_to do |format|
      if @download.update(download_params)
        format.html { redirect_to @download, notice: 'Aggregate download was successfully updated.' }
        format.json { render :show, status: :ok, location: @download }
      else
        format.html { render :edit }
        format.json { render json: @download.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downloads/1
  # DELETE /downloads/1.json
  def destroy
    @download.destroy
    respond_to do |format|
      format.html { redirect_to downloads_url, notice: 'Aggregate download was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_download
      @download = Download.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def download_params
      params.require(:download).permit(:episode_id, :day, :volume, :hits, :count)
    end
end
