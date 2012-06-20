require 'bundler/setup'

task :default => [:jekyll]

task :slow_warning do
  puts "Generating pygments cache, this may take a while. Subsequent runs will be faster." unless File.exists? '_cache'
end

desc "Run jekyll and create the _site dir"
task :jekyll => [:slow_warning] do
  exec "bundle exec jekyll"
end

desc "Run the jekyll server"
task :server => [:slow_warning] do
  exec "bundle exec jekyll --server --auto"
end

namespace :server do
  desc "Run the jekyll server, only generate 5 most recent posts"
  task :recent => [:slow_warning] do
    num = ENV['LIMIT'] || 5
    exec "bundle exec jekyll --server --auto --limit_posts #{num}"
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


namespace :news do
  desc "Create a Blank News Item (Run in the project's root directory)"
  task :create do
    Dir.chdir Rake.application.original_dir
    if !Dir.exists? 'news/_posts'
      STDOUT.puts 'The directory "news/_posts/" was not found, are you in the root directory of the project?'
      return
    end

    # Front YAML container
    yaml_data = {}

    # File type
    file_extension = '.markdown'

    # Ask the user if .markdown is ok
    STDOUT.puts "\nThe default post type is markdown. If you want to write the news story in markdown press enter, otherwise enter a different extension (i.e. html):"
    new_extension = STDIN.gets.strip
    file_extension = '.' + new_extension if new_extension.length > 1

    STDOUT.puts "\nAll of the following collected data can be changed by editting the YAML at the top of the generated post."

    # Query for title
    STDOUT.puts "\nPlease enter the TITLE of the news story:"
    raw_title = STDIN.gets.strip
    raw_title = '"' + raw_title + '"' if raw_title.include? ':'
    yaml_data['title'] = raw_title
    
    # Assign date to current time
    yaml_data['date'] = Time.now.to_s
    
    # Use news layout
    yaml_data['layout'] = 'news'

    # Create date portion of title
    news_date_title = ["%02d" % Time.now.year, "%02d" % Time.now.month, "%02d" % Time.now.day].join '-'

    # Shorten the title to soemthing readable in the url (do not cut off mid word)
    news_end_title = ''
    title_words = yaml_data['title'].downcase.split(' ')
    title_words.each_with_index do |word, index|
      news_end_title += word
      break if news_end_title.length >= 60
      news_end_title += '-' if index < title_words.count - 1
    end

    # Full news title
    full_title = news_date_title + '-' + news_end_title + file_extension

    # Open the news post file and write the data to the file
    File.open('news/_posts/' + full_title, 'w') do |news_post|  
      news_post.puts '---'
      yaml_data.each do |key, value|
        news_post.puts key + ': ' + value
      end
      news_post.puts '---'
      news_post.puts '(INSERT NEWS CONTENT)' 
    end
    
    STDOUT.puts "\nGenerated news post #{raw_title} at news/_posts/#{full_title}"
  end
end

namespace :published_work do
  desc "Create a Blank Published Work Post (Run in the project's root directory)"
  task :create do
    Dir.chdir Rake.application.original_dir
    if !Dir.exists? 'published_works/_posts'
      STDOUT.puts 'The directory "published_works/_posts/" was not found, are you in the root directory of the project?'
      return
    end

    # Front YAML container
    yaml_data = {}

    # File type
    file_extension = '.markdown'

    # Ask the user if .markdown is ok
    STDOUT.puts "\nThe default post type is markdown. If you want to write the published work post in markdown press enter, otherwise enter a different extension (i.e. html):"
    new_extension = STDIN.gets.strip
    file_extension = '.' + new_extension if new_extension.length > 1

    STDOUT.puts "\nAll of the following collected data can be changed by editting the YAML at the top of the generated post."

    # Query for title
    STDOUT.puts "\nPlease enter the TITLE of the published work:"
    raw_title = STDIN.gets.strip
    raw_title = '"' + raw_title + '"' if raw_title.include? ':'
    yaml_data['title'] = raw_title
    
    # Query For Tags
    STDOUT.puts "\nPlease enter the relevant TAGS (space delimited) for the published work:"
    yaml_data['tags'] = STDIN.gets.strip.downcase
    
    # Assign date to current time
    yaml_data['date'] = Time.now.to_s
    
    # Use news layout
    yaml_data['layout'] = 'news'

    # Create date portion of title
    date_title = ["%02d" % Time.now.year, "%02d" % Time.now.month, "%02d" % Time.now.day].join '-'

    # Shorten the title to soemthing readable in the url (do not cut off mid word)
    short_title = ''
    title_words = yaml_data['title'].downcase.split(' ')
    title_words.each_with_index do |word, index|
      short_title += word
      break if short_title.length >= 60
      short_title += '-' if index < title_words.count - 1
    end

    # Full published work title
    full_title = date_title + '-' + short_title + file_extension

    # Open the published work post file and write the data to the file
    File.open('published_works/_posts/' + full_title, 'w') do |post|  
      post.puts '---'
      yaml_data.each do |key, value|
        post.puts key + ': ' + value
      end
      post.puts '---'
      post.puts '(INSERT PUBLISHED WORK CONTENT)' 
    end
    
    STDOUT.puts "\nGenerated published work post #{raw_title} at published_works/_posts/#{full_title}"
  end
end

namespace :speaking_engagement do
  desc "Create a blank speaking post (Run in the root directory of the project)"
  task :create do
    # Fail if we're not in the project's root directory
    Dir.chdir Rake.application.original_dir
    if !Dir.exists? 'speaking'
      STDOUT.puts "\nPlease run this command from the root directory of the project"
      return
    end
    
    # Get the speaker's name
    STDOUT.puts "\nEnter the speaker's first name:"
    first_name = STDIN.gets.strip
    STDOUT.puts "\nEnter the speaker's last name:"
    last_name = STDIN.gets.strip
    
    folder_name = 'speaking/' + first_name.downcase + '_' + last_name.downcase
    
    # Create the speaker's directory if it doesn't already exist
    if !Dir.exists? folder_name
      Dir.mkdir folder_name
      Dir.mkdir folder_name + '/_posts'
      File.open folder_name + '/_posts/.gitignore', 'w'
    end
    
    Dir.chdir folder_name
    
    # Ask about the type of file
    file_extension = '.markdown'
    STDOUT.puts "\nPress enter to create a markdown file, otherwise enter a different extension (i.e. html):"
    new_extension = STDIN.gets.strip
    file_extension = '.' + new_extension if new_extension.length > 1
    
    # Get the title of the talk
    STDOUT.puts "\nEnter the TITLE of the talk:"
    title = STDIN.gets.strip
    
    # Get the date of the talk
    STDOUT.puts "\nEnter the DATE of the talk in the format YYYY-MM-DD:"
    date = STDIN.gets.strip.downcase    
    
    # Create the file name of the post
    short_title = ''
    title_words = title.downcase.split(' ')
    title_words.each_with_index do |word, index|
      short_title += word
      break if short_title.length >= 60
      short_title += '-' if index < title_words.count - 1
    end
    file_name = date + '-' + short_title + file_extension
    
    # Create the file with the default header
    File.open('_posts/' + file_name, 'w') do |post|  
      post.puts '---'
      post.puts 'layout: speaking'
      post.puts 'title: ' + title
      post.puts 'date: ' + date
      post.puts 'tags: # Space delimited'
      post.puts 'location: # i.e. Reston, Virginia'
      post.puts 'talk_url: # Link to additional information about the talk'
      post.puts ''
      post.puts '# Use either the conference or user_group attribute'
      post.puts 'conference: '
      post.puts '  name: # Name of the conference'
      post.puts '  url: # Website for the conference'
      post.puts 'user_group: '
      post.puts '  name: # Name of the user group'
      post.puts '  url: # Website for the user group'
      post.puts '---'
    end
    
    STDOUT.puts 'Successfully generated blank post at ' + folder_name + '/_posts/' + file_name
  end
end

namespace :tech_talk do
  desc "Create a blank tech talk post (Run in the root directory of the project)"
  task :create do
    # Fail if we're not in the project's root directory
    Dir.chdir Rake.application.original_dir
    if !Dir.exists? 'techtalks'
      STDOUT.puts "\nPlease run this command from the root directory of the project"
      return
    end
    
    # Get the presenter's name
    STDOUT.puts "\nEnter the presenter's first name:"
    first_name = STDIN.gets.strip
    STDOUT.puts "\nEnter the presenter's last name:"
    last_name = STDIN.gets.strip
    
    folder_name = 'techtalks/' + first_name.downcase + '_' + last_name.downcase
    
    # Create the presenters's directory if it doesn't already exist
    if !Dir.exists? folder_name
      Dir.mkdir folder_name
      Dir.mkdir folder_name + '/_posts'
      File.open folder_name + '/_posts/.gitignore', 'w'
    end
    
    Dir.chdir folder_name
    
    # Ask about the type of file
    file_extension = '.markdown'
    STDOUT.puts "\nPress enter to create a markdown file, otherwise enter a different extension (i.e. html):"
    new_extension = STDIN.gets.strip
    file_extension = '.' + new_extension if new_extension.length > 1
    
    # Get the title of the tech talk
    STDOUT.puts "\nEnter the TITLE of the tech talk:"
    title = STDIN.gets.strip
    
    # Get the date of the tech talk
    STDOUT.puts "\nEnter the DATE of the tech talk in the format YYYY-MM-DD:"
    date = STDIN.gets.strip  
    
    # Get the tags of the tech talk
    STDOUT.puts "\nEnter the relevant TAGS (space delimited) for the tech talk:"
    tags = STDIN.gets.strip.downcase 
        
    # Get the unique id of the youtube video
    STDOUT.puts "\nEnter the unique ID of the youtube video"
    unique_id = STDIN.gets.strip
    
    # Create the file name of the post
    short_title = ''
    title_words = title.downcase.split(' ')
    title_words.each_with_index do |word, index|
      short_title += word
      break if short_title.length >= 60
      short_title += '-' if index < title_words.count - 1
    end
    file_name = date + '-' + short_title + file_extension
    
    # Create the file with the default header
    File.open('_posts/' + file_name, 'w') do |post|  
      post.puts '---'
      post.puts 'title: ' + title
      post.puts 'tags: ' + tags
      post.puts 'unique_id: ' + unique_id
      post.puts '---'
      post.puts '(INSERT CONTENT HERE)'
    end
    
    STDOUT.puts 'Successfully generated blank post at ' + folder_name + '/_posts/' + file_name
  end
end