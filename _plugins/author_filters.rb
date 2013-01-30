module Jekyll
  module AuthorFilters
    # Returns a list of all authors
    def authors_list(site, type)
      categories = site['categories'].clone
      categories.reject!{ |category_key, category_post| ['blogs', 'techtalks', 'speaking', 'news', 'published_works'].include? category_key }
      categories.reject! do |category_key, category_posts|
        category_posts.select{ |post|
          post.categories[0] == type
        }.empty?
      end

      categories.reject!{ |category_key, category_post| is_inactive?(category_key, site) }

      categories.keys.sort{|a,b|a.split('_')[1] <=> b.split("_")[1]}.map{ |user|
        "<li><a href='#{author_content_url(user, type)}' class='author-filter'>#{user_to_name(user)}</a></li>"
      }.compact.join
    end

    def author_url(user)
      check_url = Dir.pwd.split('/').last == 'www.nearinfinity.com' ? "/who_we_are/bios/#{user}" : "../who_we_are/bios/#{user}"
      return "/who_we_are/bios/#{user}" if Dir.exists?(check_url)
      return "/blogs/#{user}"
    end

    def author_content_url(user, type)
      "/#{type}/#{user}/all"
    end

    # Return a list of the COUNT most recent blogs by an author
    def recent_blogs_list(page, count = 3)
      author = page['user'] || page['categories'][1]
      all_blogs = @context.registers[:site].categories['blogs']
      all_blogs_by_author = all_blogs.reject{ |post|
        !post.categories.include? author
      }.sort{|a,b| b.date <=> a.date}
      all_blogs_by_author[0..count-1].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    # Return a list of the COUNT of the future speaking engagements for an author
    def future_speaking_engagements(page, count = 2)
      author = page['user'] || page['categories'][1]
      all_speaking = @context.registers[:site].categories['speaking']
      all_future_speaking_by_author = all_speaking.reject{ |post|
        !post.categories.include? author
      }.sort{|a,b| b.date <=> a.date}
      all_future_speaking_by_author[0..count-1].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    # Return a list of the COUNT most recent tech talks by an author
    def recent_techtalks_list(page, count = 3)
      author = page['user'] || page['categories'][1]
      all_techtalks = @context.registers[:site].categories['techtalks']
      all_techtalks_by_author = all_techtalks.reject{ |post|
        !post.categories.include? author
      }.sort{|a,b| b.date <=> a.date}
      all_techtalks_by_author[0..count-1].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    # Return a list of the COUNT most recent published works by an author
    def recent_published_works_list(page, count = 3)
      author = page['user'] || page['categories'][1]
      all_published_works = @context.registers[:site].categories['published_works']
      all_published_works_by_author = all_published_works.reject{ |post|
        !post.categories.include? author
      }.sort{|a,b| b.date <=> a.date}
      all_published_works_by_author[0..count-1].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    def social_link(media)
      rel = ""
      if media[0] == "google-plus"
        rel = "me"
      end

      socialMap = {
        "twitter" => "Twitter",
        "google-plus" => "Google+",
        "facebook" => "Facebook",
        "github" => "Github",
        "you-tube" => "YouTube",
        "LinkedIn" => "LinkedIn"
      }

      "<li><a class='icon #{media[0]}' rel='#{rel}' href='#{media[1]}'>#{socialMap[media[0]]}</a></li>"
    end

    def by_name(folder)
      folder.split("_").map{|x| x.capitalize }.join(" ")
    end

    private
    def is_inactive?(user, site)
      employee_pages = site['pages'].select do |page|
        directory_parse = page.instance_variable_get('@dir').split('/')
        bio_sub_directory?(directory_parse) && directory_parse.last == user
      end
      employee_page = employee_pages.first

      return false if !employee_page

      return true if employee_page.data['inactive']

      false
    end

    def bio_sub_directory?(dir_parse)
      return true if dir_parse.include? 'blogs' and dir_parse.length > 2
      return true if dir_parse.include? 'who_we_are' and dir_parse.include? 'bios'
      return false
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorFilters)
