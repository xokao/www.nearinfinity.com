task :default => [:jekyll]

task :slow_warning do
  puts "Generating pygments cache, this may take a while. Subsequent runs will be faster." unless File.exists? '_cache'
end

desc "Run jekyll and create the _site dir"
task :jekyll => [:slow_warning] do
  `bundle exec jekyll`
end

desc "Run the jekyll server"
task :server => [:slow_warning] do
  `bundle exec jekyll --server --auto`
end

namespace :server do
  desc "Run the jekyll server, only generate 5 most recent posts"
  task :recent => [:slow_warning] do
    `bundle exec jekyll --server --auto --limit_posts 5`
  end
end

namespace :assets do

  task :list_data_uris do
    require 'rack'
    require 'base64'

    Dir['assets/images/**/*.png'].each do |file|
      if File.size(file) < 30000
        base64 = Base64.encode64(File.read file)
        puts "#{File.basename file}\n\tdata:image/png;base64,#{Rack::Utils.escape(base64)}\n\n"
      end
    end
    Dir['assets/images/**/*.jpg'].each do |file|
      if File.size(file) < 30000
        base64 = Base64.encode64(File.read file)
        puts "#{File.basename file}\n\tdata:image/jpg;base64,#{Rack::Utils.escape(base64)}\n\n"
      end
    end
  end

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


  desc "Sprite users"
  task :sprite_users do
    require 'fileutils'

    dir = 'assets/images/users'
    users = "#{dir}/*.png"
    dest = "#{dir}/sprites/small.png"
    width = 20
    padding = 2
    `montage #{users} -geometry #{width}x#{width}+#{padding}+#{padding} -tile 0x1 -background transparent #{dest}`

    final = dest.gsub 'small', 'small-saturated' 
    `convert #{dest} -modulate 100,25,100 #{final}`
   
    File.open("#{dir}/sprites/users.less", 'w') do |f|
      f.puts """
      .user_spr {
        background: url(/#{final}) no-repeat;
        width: #{width + padding * 2}px;
        height: #{width + padding * 2}px;
        margin-top: -2px;
        float: left;
      }
      """
      Dir[users].each_with_index do |user, index|
        f.puts ".user_spr-#{File.basename(user).gsub('.png','')} { background-position-x: #{index * -(width+padding*2)}px; }"
      end
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
