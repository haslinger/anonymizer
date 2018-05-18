namespace :episodes do


  task fix: :environment do
    Download.where("count > ?", 1000).each do |download|
      episode = Episode.find(download.episode_id)
      download.update(count: (download.volume.to_f / episode.filesize.to_f).ceil)
    end
  end


  task import: :environment do
    require 'zlib'
    require 'net/http'

    path_to_logfiles =
      Rails.env == "development" ? "./logfiles/" : "/var/log/apache2/"

    logfile = path_to_logfiles + "other_vhosts_access.log.1"
    logline_regex = /(.*):.* - .* \[(\d*)\/(\w*)\/(\d*).*\] .* (.*) .* \d* (\d*) .*/
    filename_regex = /.*\/(.*)\..*\z/

    downloads = Download.all.to_a

    puts "Parsing file " +  File.basename(logfile)

    File.foreach(logfile) do |line|
      if ['.mp3 ','.ogg ','.m4a ', '.opus '].any? { |word| line.include?(word) }
        matchdata = logline_regex.match(line)

        day = Date.new(matchdata[4].to_i, Date::ABBR_MONTHNAMES.index(matchdata[3]), matchdata[2].to_i)
        filename = filename_regex.match(matchdata[5])[1]

        episode = Episode.joins(:podcast).find_or_create_by("podcasts.name": matchdata[1], name: filename)
        size = matchdata[6].to_i

        unless episode.filesize.to_i > 0
          puts "Deriving Filesize for " + episode.podcast
          path = Podcast.find_by(name: episode.podcast).path
          url = URI(path + URI.escape(episode.name) + ".mp3")

          Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https'){|http|
             response = http.head(url.path)

             name_matches = /(\d+)/.match(episode.name)
             episode.update(filesize: [response.content_length.to_i, 1].max,
                            number: name_matches ? name_matches[1].to_i : "99")
          }
        end

        download = downloads.detect{ |d| d.day == day && d.episode_id == episode.id }

        if download
          download.assign_attributes(hits: download.hits + 1,
                                     volume: (download.volume + size).to_i,
                                     count: ((download.volume + size).to_f / episode.filesize.to_f).ceil)
        else
          downloads << Download.new(day: day,
                                             episode: episode,
                                             hits: 1,
                                             volume: size,
                                             count: (size.to_f / episode.filesize.to_f).ceil)
        end
      end
    end

    puts "Deleting old stats"
    Download.delete_all

    puts "Persisting new stats"
    Download.import downloads

    puts "Vacuum Database"
    ActiveRecord::Base.connection.execute("VACUUM")
  end
end
