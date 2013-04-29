require 'bundler/setup'
require 'yaml'
require 'csv'
require 'faraday'
require 'json'

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

  desc "Export news to json file"
  task :export do
    news = []
    Dir.entries('news/_posts').each do |file_name|
      next if skip_file?(file_name)

      file_data = {}
      File.open("news/_posts/#{file_name}", 'r') do |f|
        file_data = process_yaml_file(f)
      end

      path_date = path_date_for(file_data, file_name)
      path_file_name = path_file_name_for(file_name)
      file_data['path'] = "/news/#{path_date}/#{path_file_name}"

      file_data['filename'] = file_name

      news << file_data
    end

    File.open('news_export.json', 'w') {|f| f.write(news.to_json) }

    puts "Exported #{news.size} news stories to news_export.json"
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

    # Ask for date
    STDOUT.puts "\nEnter the date of the published work in the format YYYY-MM-DD"
    yaml_data['date'] = STDIN.gets.strip

    # Shorten the title to soemthing readable in the url (do not cut off mid word)
    short_title = ''
    title_words = yaml_data['title'].downcase.split(' ')
    title_words.each_with_index do |word, index|
      short_title += word
      break if short_title.length >= 60
      short_title += '-' if index < title_words.count - 1
    end

    # Full published work title
    full_title = yaml_data['date'] + '-' + short_title + file_extension

    # Set permalink attribute
    # yaml_data['permalink'] = '/published_works/'

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

  desc "Export published works to json file"
  task :export do
    published_works = {}
    count = 0

    short_names = get_short_names

    Dir.entries('published_works/').each do |folder|
      next if skip_file?(folder)

      next if !(profile_data = profile_data_for_blog_name(folder))
      employee_number = profile_data['employee_number']
      short_name = short_names[employee_number.to_s]

      published_works[short_name] = []

      Dir.entries("published_works/#{folder}/_posts/").each do |file_name|
        next if skip_file?(file_name)
        count = count + 1

        file_data = {}
        File.open("published_works/#{folder}/_posts/#{file_name}", 'r') {|f| file_data = process_yaml_file(f) }

        path_date = path_date_for(file_data, file_name)
        path_file_name = path_file_name_for(file_name)
        file_data['path'] = "/published_works/#{folder}/#{path_date}/#{path_file_name}.html"
        file_data['filename'] = file_name
        published_works[short_name] << file_data
      end
    end

    File.open('published_works_export.json', 'w') {|f| f.write(published_works.to_json) }

    puts "Exported #{count} published works to published_works_export.json"
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
      post.puts 'title: ' + title
      post.puts 'date: ' + date
      post.puts 'tags: # Space delimited'
      post.puts 'location: # i.e. Reston, Virginia'
      post.puts 'talk_url: # Link to additional information about the talk (with "http://")'
      post.puts ''
      post.puts '# Use either the conference or user_group attribute'
      post.puts 'conference: '
      post.puts '  name: # Name of the conference'
      post.puts '  url: # Website for the conference (with "http://")'
      post.puts 'user_group: '
      post.puts '  name: # Name of the user group'
      post.puts '  url: # Website for the user group (with "http://")'
      post.puts '---'
    end

    STDOUT.puts 'Successfully generated blank post at ' + folder_name + '/_posts/' + file_name
  end

  desc "Export speaking engagements to json file"
  task :export do
    speaking_engagements = {}
    count = 0

    short_names = get_short_names

    Dir.entries('speaking/').each do |folder|
      next if skip_file?(folder)

      next if !(profile_data = profile_data_for_blog_name(folder))
      employee_number = profile_data['employee_number']
      short_name = short_names[employee_number.to_s]

      speaking_engagements[short_name] = []

      Dir.entries("speaking/#{folder}/_posts/").each do |file_name|
        next if skip_file?(file_name)
        count = count + 1

        file_data = {}
        File.open("speaking/#{folder}/_posts/#{file_name}", 'r') {|f| file_data = process_yaml_file(f) }

        path_date = path_date_for(file_data, file_name)
        path_file_name = path_file_name_for(file_name)
        file_data['path'] = "/speaking/#{folder}/#{path_date}/#{path_file_name}.html"
        file_data['filename'] = file_name
        speaking_engagements[short_name] << file_data
      end
    end

    File.open('speaking_engagements_export.json', 'w') {|f| f.write(speaking_engagements.to_json) }

    puts "Exported #{count} speaking engagements to speaking_engagements_export.json"
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
      post.puts '(INSERT DESCRIPTION HERE)'
    end

    STDOUT.puts 'Successfully generated blank post at ' + folder_name + '/_posts/' + file_name
  end

  desc "Export tech talks to json file"
  task :export do
    tech_talks = {}
    count = 0

    short_names = get_short_names

    Dir.entries('techtalks/').each do |folder|
      next if skip_file?(folder)

      next if !(profile_data = profile_data_for_blog_name(folder))
      employee_number = profile_data['employee_number']
      short_name = short_names[employee_number.to_s]

      tech_talks[short_name] = []

      Dir.entries("techtalks/#{folder}/_posts/").each do |file_name|
        next if skip_file?(file_name)
        count = count + 1

        file_data = {}
        File.open("techtalks/#{folder}/_posts/#{file_name}", 'r') {|f| file_data = process_yaml_file(f) }

        path_date = path_date_for(file_data, file_name)
        path_file_name = path_file_name_for(file_name)
        file_data['path'] = "/techtalks/#{folder}/#{path_date}/#{path_file_name}.html"
        file_data['filename'] = file_name
        tech_talks[short_name] << file_data
      end
    end

    File.open('tech_talks_export.json', 'w') {|f| f.write(tech_talks.to_json) }

    puts "Exported #{count} tech talks to tech_talks_export.json"
  end
end

namespace :training_center_event do
  desc "Create a blank training center event post (Run in the root directory of the project)"
  task :create do
    # Fail if we're not in the project's root directory
    Dir.chdir Rake.application.original_dir
    if !Dir.exists? 'training_center_events'
      STDOUT.puts "\nPlease run this command from the root directory of the project"
      return
    end

    Dir.chdir 'training_center_events'

    file_extension = '.markdown'
    STDOUT.puts "\nPress enter to create a markdown file, otherwise enter a different extension (i.e. \"html\"):"
    new_extension = STDIN.gets.strip
    file_extension = '.' + new_extension if new_extension.length > 1

    STDOUT.puts "\nEnter the TITLE of the event:"
    title = STDIN.gets.strip

    STDOUT.puts "\nEnter the DATE of the event in the format \"YYYY-MM-DD\""
    date = STDIN.gets.strip

    STDOUT.puts "\nEnter the START TIME of the event in the format \"HH:MM\" (24-hour format)"
    start_time = STDIN.gets.strip

    STDOUT.puts "\n(Optional) Enter the END TIME of the event in the format \"HH:MM\" (24-hour format)"
    end_time = STDIN.gets.strip

    start_timestamp = date + ' ' + start_time
    end_timestamp = date + ' ' + end_time

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
      post.puts 'title: "' + title + '"'
      post.puts 'start_timestamp: ' + start_timestamp
      post.puts 'end_timestamp: ' + end_timestamp
      post.puts 'held_by:  # (Optional)'
      post.puts '  name:  # Name of the organization holding the event'
      post.puts '  url:  # URL of the organization holding the event (including http://)'
      post.puts 'sign_up_url:  # URL to sign up for the event (including http://)'
      post.puts '---'
      post.puts '(INSERT DESCRIPTION HERE)'
    end

    STDOUT.puts 'Successfully generated blank training center event at ' + 'training_center_events/_posts/' + file_name
  end
end

namespace :blog do
  desc "Create a Blank Blog Post (Run this in your personal blog folder)"
  task :create do
    STDOUT.puts 'Please run this command from your personal blog folder (i.e. blogs/first_last/'
  end

  desc "Create a new user's blog folder structure (Run in the blogs folder)"
  task :directory, :full_name do |t, args|
    STDOUT.puts 'Please run this command from the blogs folder'
  end

  desc "Export blogs to json file"
  task :export do
    short_names = get_short_names

    blogs = {}

    Dir.entries('blogs/').each do |folder|
      next if skip_file?(folder)

      next if !(profile_data = profile_data_for_blog_name(folder))

      employee_number = profile_data['employee_number']
      short_name = short_names[employee_number.to_s]
      blogs[short_name] = profile_data
      profile_filename = profile_data['profile_filename']
      blogs[short_name]['profile_extension'] = profile_filename[profile_filename.index('.')..-1]
      blogs[short_name]['blogs'] = []

      assets = all_assets(folder)

      Dir.foreach('blogs/' + folder + '/_posts/') do |filename|
        next if skip_file?(filename)

        file_data = {}
        File.open('blogs/' + folder + '/_posts/' + filename, 'r') do |f|
          file_data = process_yaml_file(f)
        end

        file_data['assets'] = []
        assets.each do |asset|
          if file_data['body'].include?(asset[:filename])
            asset[:blogs] ||= [filename]
            file_data['assets'] << asset[:filename]
          end
        end

        date_str = path_date_for(file_data, filename)
        real_filename = path_file_name_for(filename)

        path = "/blogs/#{folder}/#{date_str}/#{real_filename}"
        file_data['path'] = path
        file_data['filename'] = filename

        blogs[short_name]['blogs'] << file_data
      end
    end

    File.open('blogs_export.json', 'w') do |f|
      f.write(blogs.to_json)
    end

    puts "Exported blogs to blogs_export.json"
  end
end

namespace :export do
  desc "Export everything"
  task :all do
    Rake::Task['blog:export'].invoke
    Rake::Task['news:export'].invoke
    Rake::Task['published_work:export'].invoke
    Rake::Task['speaking_engagement:export'].invoke
    Rake::Task['tech_talk:export'].invoke
  end
end

def skip_file?(name)
  name.start_with?('.') || name.start_with?('Rakefile') || name.start_with?('README')
end

def get_short_names
  short_names = {}
  File.open('employees.txt', 'r') do |f|
    while (line = f.gets)
      parts = line.split(' ')
      short_names[parts[0]] = parts[1]
    end
  end
  short_names
end

def process_yaml_file(file)
  front = ''
  body = ''

  seen_dashes = 0
  while (line = file.gets)
    if (line.start_with?('---') && seen_dashes < 2)
      seen_dashes = seen_dashes + 1
    elsif (seen_dashes == 1)
      front += line
    else
      body += line
    end
  end

  hash = YAML.parse(front).to_ruby
  hash['body'] = body
  hash
end

def all_assets(user)
  assets_path = "blogs/#{user}/assets"
  return [] if !File.exists?(assets_path)
  inspect_sub_dir(assets_path)
end

def inspect_sub_dir(path)
  assets = []
  Dir.foreach(path) do |asset|
    next if skip_file?(asset)

    asset_path = path + '/' + asset
    if File.directory?(asset_path)
      assets.concat(inspect_sub_dir(asset_path))
    else
      # FileUtils.cp(asset_path, '/tmp/assets')
      assets << { filename: asset_path.split('/').last }
    end
  end
  assets
end

def path_date_for(file_data, file_name)
  if file_data['date']
    file_data['date'].strftime("%Y/%m/%d")
  elsif file_name.start_with?('_')
    file_name[1..10].gsub('-', '/')
  else
    file_name[0..9].gsub('-', '/')
  end
end

def path_file_name_for(file_name)
  if (file_name.start_with?('_'))
    path_file_name = file_name[12..-1]
  else
    path_file_name = file_name[11..-1]
  end

  path_file_name[0..path_file_name.rindex('.')] + 'html'
end

def profile_data_for_blog_name(blog_name)
  entries = Dir.entries("blogs/#{blog_name}")
  profile = entries.find{|entry| entry.start_with?('index') }
  return nil if !profile

  profile_data = {}
  File.open("blogs/#{blog_name}/#{profile}", 'r') do |f|
    profile_data = process_yaml_file(f)
  end
  profile_data['profile_filename'] = profile
  profile_data
end

def employee_number_for_blog_name(blog_name)
  profile_data = profile_data_for_blog_name(blog_name)
end
