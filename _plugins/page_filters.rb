module Jekyll
  module BlogsFilters
    # Returns a specific number of posts that have happened since a certain date
    def n_posts_from_date(posts, amount,date)
      posts.sort!{|a,b|a.date <=> b.date}
      filtered_posts = Array.new
      previous_size = -1
      post = posts.pop
      while filtered_posts.size < amount and filtered_posts.size > previous_size and !post.nil?
        previous_size = filtered_posts.size
        last_time = post.date
        if(last_time > date)
          filtered_posts.push(post)
        end
        post = posts.pop
      end
      filtered_posts
    end

    # Render the short blog partial for the home page
    def render_homepage_blogs(amount, offset=0)
      render_homepage_posts(amount,'blogs','homepage/blog.html',offset)
    end

    # Render the short techtalks partial for the home page
    def render_homepage_techtalks(amount, offset=0)
      render_homepage_posts(amount,'techtalks','homepage/techtalk.html',offset)
    end

    # Render the short speaking partial for the home page
    def render_homepage_speaking(amount, offset=0)
      render_homepage_posts(amount,'speaking','homepage/speaking.html',offset)
    end

    # Shows the list of future speaking engagements
    def render_future_speaking(template, amount)
      all_speaking = @context.registers[:site].categories['speaking']
      future_speaking = n_posts_from_date(all_speaking,amount,Time.new)
      future_speaking.map{|post| include_template(template, {'post' => post})}.compact.join
    end

    # Renders the recent news items
    def render_recent_news(template,amount,days_expire)
      all_news = @context.registers[:site].categories['news']
      time = Time.new - (days_expire * (60 * 60 * 24))
      recent_news = n_posts_from_date(all_news,amount,time)
      recent_news.map{|post| include_template(template, {'news' => post})}.compact.join
    end

    # Renders the count amount of related blogs
    def blog_with_similar_tags(blog, count = 5)
      return if blog['tags'].count == 0
      similarity_index = create_similarity_index blog, @context.registers[:site].categories['blogs']
      limited_related_blogs = create_most_related_array similarity_index
      limited_related_blogs[0..count].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    def render_posts_by_tag(type,tag,amount)
      all_posts = @context.registers[:site].categories[type]
      filtered_posts = all_posts.reject{|post| ! post.tags.include? tag}.sort{|a,b| b.date <=> a.date}
      filtered_posts = filtered_posts[0..(amount-1)] if filtered_posts.size > amount
      markup = ''
      if filtered_posts.size > 0
        markup = filtered_posts.map{|post| "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"}.compact.join
      else
        markup = '<li><h1>No Posts Found</h1></li>'
      end
      markup += "<li><a href='/tags/#{type}/#{tag}.html'>View All</a></li>"
    end

    private
    # Renders the list of type posts for the home page
    def render_homepage_posts(amount, type, template,offset)
      all_blogs = @context.registers[:site].categories[type]
      hiddenIds = @context.registers[:site].config['hideFromHomepage']
      filtered_blogs = all_blogs.reject{ |blog| hiddenIds.include? blog.id }
      filtered_blogs.sort{|a,b| b.date <=> a.date}[offset..((offset + amount) - 1)]
        .map{|blog| include_template(template, {'post' => blog})}.compact.join
    end

    # Creates a hash of key: similarity number to value: array of posts with that value
    def create_similarity_index(blog, all_blogs)
      similarity_index = {}
      all_blogs.each do |compared_blog|
        next if compared_blog.id == blog['id']
        # Number of same tags (similarity number)
        similarity = (blog['tags'] & compared_blog.tags).length
        similarity_index[similarity] = [] unless similarity_index.has_key? similarity
        similarity_index[similarity] << compared_blog
      end
      # Remove the unrelated posts (efficiency)
      similarity_index.delete 0
      similarity_index.each{|key, blog_list| blog_list.sort!{|a,b| b.date <=> a.date}}
    end

    # Pulls from a similarity hash and creates an array of the most relevant posts
    def create_most_related_array(similarity_index)
      limited_related_blogs = []
      similarity_index.keys.reverse.each do |index|
        break if limited_related_blogs.count >= 5
        limited_related_blogs << similarity_index[index]
        limited_related_blogs.flatten!
      end
      limited_related_blogs
    end
  end
end

Liquid::Template.register_filter(Jekyll::BlogsFilters)