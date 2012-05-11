module Jekyll
  module BlogsFilters
    def render_homepage_posts(amount,type,template,offset)
      all_blogs = @context.registers[:site].categories[type]
      hiddenIds = @context.registers[:site].config['hideFromHomepage']
      filtered_blogs = all_blogs.reject{ |blog| hiddenIds.include? blog.id }
      filtered_blogs.sort{|a,b| b.date <=> a.date}[offset..((offset + amount) - 1)]
        .map{|blog| include_template(template, {'post' => blog})}.compact.join
    end

    def n_posts_from_date(posts,amount,date)
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
    def render_homepage_techtalks(amount,offset=0)
      render_homepage_posts(amount,'techtalks','homepage/techtalk.html',offset)
    end

    # Render the short speaking partial for the home page
    def render_homepage_speaking(amount,offset=0)
      render_homepage_posts(amount,'speaking','homepage/speaking.html',offset)
    end

    def render_future_speaking(template,amount)
      all_speaking = @context.registers[:site].categories['speaking']
      future_speaking = n_posts_from_date(all_speaking,amount,Time.new)
      future_speaking.map{|post| include_template(template, {'post' => post})}.compact.join
    end

    def render_recent_news(template,amount,days_expire)
      all_news = @context.registers[:site].categories['news']
      time = Time.new - (days_expire * (60 * 60 * 24))
      recent_news = n_posts_from_date(all_news,amount,time)
      recent_news.map{|post| include_template(template, {'news' => post})}.compact.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::BlogsFilters)