namespace :episodes do
  task import: :environment do
    require 'zlib'

    path_to_logfiles =
      Rails.env == "development" ? "./logfiles/" : "/var/log/apache2/"

    zipfiles = Dir[path_to_logfiles + "*.gz"]
    logline_regex = /(.*):.* - .* \[(\d*)\/(\w*)\/(\d*).*\] .* (.*) .* \d* (\d*) .*/
    filename_regex = /.*\/(.*)\..*\z/

    zipfiles.each do |zipfile |
      Zlib::GzipReader.open(zipfile) do |reader|
        reader.each_line do |line|
          if ['.mp3 ','.ogg ','.m4a ', '.opus '].any? { |word| line.include?(word) }
            matchdata = logline_regex.match(line)
            begin
              day = Date.new(matchdata[4].to_i, Date::ABBR_MONTHNAMES.index(matchdata[3]), matchdata[2].to_i)
            rescue NoMethodError
              byebug
            end
            filename = filename_regex.match(matchdata[5])[1]

            episode = Episode.find_or_create_by(podcast: matchdata[1],
                                                name: filename)
            download = Download.create(episode: episode,
                                       size: matchdata[6],
                                       day: day)
            putc "."
          end
        end
      end

      puts "deleteing " +  File.basename(zipfile)
      File.delete(zipfile)
    end
  end


  task get_filesizes: :environment do
    require 'net/http'

    Episode.where(filesize: nil).each do |episode|
      path = Podcast.find_by(name: episode.podcast).path

      url = URI(path + episode.name + ".mp3")

      Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https'){|http|
         response = http.head(url.path)
         episode.update_attribute(:filesize, response.content_length)
         episode.update_attribute(:number, /(\d+)/.match(episode.name)[1].to_i)
      }
    end
  end


 task aggregate: :environment do
    Download.all.each do |download|
      aggregate_download = AggregateDownload.find_or_initialize_by(day: download.day,
                                                                   episode: download.episode)
      filesize = Episode.find(aggregate_download.episode_id).filesize.to_i
      new_volume = (aggregate_download.volume || 0) + download.size
      aggregate_download.update(hits: (aggregate_download.hits || 0) + 1,
                                volume: new_volume,
                                count: (new_volume / filesize.to_f).ceil)
      download.delete

      putc "."
    end
  end

  task vacuum: :environment do
    ActiveRecord::Base.connection.execute("VACUUM")
  end
end
