json.extract! aggregate_download, :id, :episode_id, :day, :volume, :hits, :count, :created_at, :updated_at
json.url aggregate_download_url(aggregate_download, format: :json)
