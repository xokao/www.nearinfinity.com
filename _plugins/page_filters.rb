module Jekyll
  module BlogsFilters
    # Returns a specific number of posts that have happened since a certain date
    def n_posts_from_date(posts, amount, date)
      posts.sort{|a,b|b.date <=> a.date}.select{|post| post.date > date}.slice(0,amount)
    end

    # Render the short blog partial for the home page
    def render_homepage_blogs(amount, offset=0)
      render_homepage_posts(amount,'blogs','homepage/blog.html',offset)
    end

    # Render the short techtalks partial for the home page
    def render_homepage_techtalk(site)
      all_talks = @context.registers[:site].categories['techtalks']
      hiddenIds = @context.registers[:site].config['hideFromHomepage']
      filtered_talks = all_talks.reject{ |talk| hiddenIds.include? talk.id }
        .sort{|a,b| b.date <=> a.date}
      selected_talk = filtered_talks.first
      if selected_talk.nil? or selected_talk.date < (Time.now - 60*60*24*30)
        filtered_talks.select{|talk| talk.date >= (Time.now - 60*60*24*365)}
          .map{|talk| include_template('homepage/techtalk.html', {'post' => talk})}.compact.join
      else
        include_template('homepage/techtalk.html', {'post' => selected_talk})
      end
    end

    # Render the short speaking partial for the home page
    def render_homepage_speaking(amount, offset=0)
      render_homepage_posts(amount,'speaking','homepage/speaking.html',offset)
    end

    # Shows the list of future speaking engagements
    def render_future_speaking(template, amount)
      all_speaking = @context.registers[:site].categories['speaking']
      future_speaking = n_posts_from_date(all_speaking,amount,(Time.new - 60*60*24*7))
      future_speaking.map{|post| include_template(template, {'post' => post})}.compact.join
    end

    # Renders the recent news items
    def render_recent_news(template,amount,days_expire)
      all_news = @context.registers[:site].categories['news']
      time = Time.new - (days_expire * (60 * 60 * 24))
      recent_news = n_posts_from_date(all_news,amount,time)
      recent_news.map{|post| include_template(template, {'news' => post})}.compact.join
    end

    def render_job_ad(tags)
      if tags.length > 0
        tags.map!{|tag|tag.downcase}
        jobs = @context.registers[:site].config['jobs_whitelist']
        filtered_jobs = jobs.reject{|job,job_tags|(tags & job_tags.map{|tag|tag.downcase}).size < 1}
        job = filtered_jobs.keys.first
        title = "#{job} expert"
      else
        title = "developer"
      end
      if title.strip.start_with?("a", "e", "i", "o", "u")
        title_with_article = "an #{title}"
      else
        title_with_article = "a #{title}"
      end
      "<div class='widget' style='margin-top: 60px;'><div class='tab'>Join Us</div>Are you #{title_with_article} looking for a fun place to work in the DC area? Near Infinity is hiring! Check out our <a href='/join_us/open_positions'>open positions</a> or <a href='mailto:careers@nearinfinity.com'>submit your resume</a>.</div>"
    end
    
    def render_youtube_thumbnail(id)
      "http://i.ytimg.com/vi/#{id}/mqdefault.jpg"
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
  end
end

Liquid::Template.register_filter(Jekyll::BlogsFilters)