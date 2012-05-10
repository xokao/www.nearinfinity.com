module Jekyll
  module AuthorContentFilters
    include Jekyll::ContentFilters

    # Return a list of the COUNT most recent blogs by an author
    def recent_blogs_list(author, count = 5)
      all_blogs = @context.registers[:site].categories['blogs']
      all_blogs_by_author = all_blogs.reject{ |post|
        !post.categories.include? author
      }.reverse
      all_blogs_by_author[0..count].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    # Return a list of the COUNT of the future speaking engagements for an author
    def future_speaking_engagements(author, count = 2)
      all_speaking = @context.registers[:site].categories['speaking']
      all_future_speaking_by_author = all_speaking.reject{ |post|
        !post.categories.include? author
      }.reverse
      all_future_speaking_by_author[0..count].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    # Return a list of the COUNT most recent tech talks by an author
    def recent_techtalks_list(author, count = 3)
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

Liquid::Template.register_filter(Jekyll::AuthorContentFilters)