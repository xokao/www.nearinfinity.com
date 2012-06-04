module Jekyll
  module AuthorFilters
    # Returns a list of all authors
    def authors_list(site, sort = true)
      authors = site['categories'].keys.reject{|category|
        ['blogs', 'techtalks', 'news', 'speaking'].include? category
      }.sort{|a,b|a.split('_')[1] <=> b.split("_")[1]}.map{ |user|
        "<li><a href='#{author_url(user)}' class='author-filter'><img class='tiny-portrait' src='#{user_image(user)}'/>#{user_to_name(user)}</a></li>"
      }.compact.join
    end

    def author_url(user)
      "/blogs/#{user}"
    end

    # Return a list of the COUNT most recent blogs by an author
    def recent_blogs_list(page, count = 5)
      author = page['user'] || page['categories'][1]
      all_blogs = @context.registers[:site].categories['blogs']
      all_blogs_by_author = all_blogs.reject{ |post|
        !post.categories.include? author
      }.sort{|a,b| b.date <=> a.date}
      all_blogs_by_author[0..count].map{ |post|
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
      all_future_speaking_by_author[0..count].map{ |post|
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
      all_techtalks_by_author[0..count].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorFilters)