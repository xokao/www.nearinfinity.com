
desc "Generate posts for tech talks on youtube"
task :generate_tech_talks do
  require 'youtube_it'

  client = YouTubeIt::Client.new(:dev_key => "AI39si4ZISyi7iYWuH8zo0ImkI-z5gne_vMnkbuFCYJiK8hhhJk3Kp7yIwqEeDelKW1UXg4EvFxHj-H1Lhap7kJSROl_kh0tIw")

  search = client.videos_by(:user => 'nearinfinity')
  search.videos.each do |video|

    print "Should I Transform: \n\t#{video.title}\n? (y/N) "
    answer = STDIN.gets.chomp

    if answer == "y"
      date = video.published_at.strftime("%Y-%m-%d")
      name = video.title.gsub(/\s*:\s*/, ':').gsub(/\s+/,'_')
      filename = "#{date}-#{name}.markdown"
      path = File.join 'techtalks','_posts', filename

      File.open(path, 'w') do |f|
        f.puts <<-EOL.gsub /^\s{8}/, ''
        ---
        layout: techtalks
        title: "#{video.title}"
        player_url: #{video.player_url}
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
end
