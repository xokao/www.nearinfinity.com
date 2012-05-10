module Jekyll
  module AuthorFilters
    include Jekyll::ContentFilters

    # Returns a list of all authors
    def authors_list(site, sort = true)
      site['categories'].keys.reject{|category|
        ['blogs', 'techtalks', 'news', 'speaking'].include? category
      }.sort.map{ |author|
        "<li><a href='#{author_url(author)}' class='author-filter'>#{author.gsub('_', ' ')}</a></li>"
      }.compact.join
    end

    def author_url(author)
      "/blogs/#{author}"
    end

    # Return a list of the COUNT most recent blogs by an author
    def recent_blogs_list(page, count = 5)
      author = page['user'] || page['categories'][1]
      all_blogs = @context.registers[:site].categories['blogs']
      all_blogs_by_author = all_blogs.reject{ |post|
        !post.categories.include? author
      }.reverse
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
      }.reverse
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
      }.reverse
      all_techtalks_by_author[0..count].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorFilters)