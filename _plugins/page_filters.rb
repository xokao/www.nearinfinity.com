module Jekyll
  module BlogsFilters
    def render_homepage_posts(amount,type,template)
      all_blogs = @context.registers[:site].categories[type]
      hiddenIds = @context.registers[:site].config['hideFromHomepage']
      filtered_blogs = all_blogs.reject{ |blog| hiddenIds.include? blog.id }
      filtered_blogs.sort{|a,b| b.date <=> a.date}[0..(amount - 1)]
        .map{|blog| include_template(template, {'post' => blog})}.compact.join
    end
  end

    def render_homepage_blogs(amount)
      puts 'derp'
      render_homepage_posts(amount,'blogs','/homepage/blogs.html')
    end

    def render_homepage_techtalks(amount)
      put 'derpderp'
      render_homepage_posts(amount,'techtalks','/homepage/techtalk.html')
    end
    def render_homepage_speaking(amount)
      render_homepage_posts(amount,'speaking','/homepage/speaking.html')
    end
end

Liquid::Template.register_filter(Jekyll::BlogsFilters)