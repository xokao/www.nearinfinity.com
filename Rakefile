task :default => [:jekyll]

desc "Run jekyll and create the _site dir"
task :jekyll do
  `bundle exec jekyll --no-pygments`
end

desc "Run the jekyll server"
task :server do
  `bundle exec jekyll --no-pygments --server --auto --limit_posts 10`
end


namespace :assets do

  desc "Crush png images"
  task :crush_pngs do
    Dir['assets/images/**/*.png'].each do |file|
      `pngcrush -rem alla -reduce -brute "#{file}" "#{file}.crushing"`
      `mv "#{file}.crushing" "#{file}"`
    end
  end

  desc "Crush jp(e)g images"
  task :crush_jpgs do
    ( Dir['assets/images/**/*.jpg'] + Dir['assets/images/**/*.jpeg'] ).each do |file|
      `jpegtran -copy none -optimize -perfect -outfile "#{file}.crushing" "#{file}"`
      `mv "#{file}.crushing" "#{file}"`
    end
  end

  desc "Crush images"
  task :crush_images do
    %w( assets:crush_pngs assets:crush_jpgs ).each do |task|
      Rake::Task[task].invoke
    end
  end

end




#desc "Generate posts for tech talks on youtube"
task :generate_tech_talks do
  require 'youtube_it'

  client = YouTubeIt::Client.new(:dev_key => "AI39si4ZISyi7iYWuH8zo0ImkI-z5gne_vMnkbuFCYJiK8hhhJk3Kp7yIwqEeDelKW1UXg4EvFxHj-H1Lhap7kJSROl_kh0tIw")

  search = client.videos_by(:user => 'nearinfinity')
  search.videos.each do |video|
    puts video.embed_html_with_width
    print "Should I Transform: \n\t#{video.title}\n? (y/N) "
    answer = STDIN.gets.chomp

    if answer == "y"
      date = video.published_at.strftime("%Y-%m-%d")
      name = video.title.gsub(/\s*:\s*/, ':').gsub(/\s+/,'_')
      filename = "#{date}-#{name}.markdown"
      path = File.join 'techtalks', filename

      File.open(path, 'w') do |f|
        f.puts <<-EOL.gsub /^\s{8}/, ''
        ---
        layout: techtalks
        title: "#{video.title}"
        player_url: #{video.player_url}
        unique_id: #{video.unique_id} 
        thumbnail_320: #{video.thumbnails.find { |t| t.width == 320 }.url}
        thumbnail_480: #{video.thumbnails.find { |t| t.width == 480 }.url}
        thumbnails_120: 
        #{video.thumbnails.find_all { |t| t.width == 120 }.collect { |v| "  - #{v.url}" }.join("\n")}
        ---
        #{video.description.gsub(/http:\/\/(www.)?nearinfinity.com\s*\n?/, "")}
        EOL
      end
    end
  end

  puts "Now place the output into their user folder"
end
