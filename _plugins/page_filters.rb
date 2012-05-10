module Jekyll
  module BlogsFilters
    def render_homepage_blogs(amount)
      all_blogs = @context.registers[:site].categories['blogs']
      hiddenIds = @context.registers[:site].config['hideFromHomepage']
      filtered_blogs = all_blogs.reject{ |blog| hiddenIds.include? blog.id }
      filtered_blogs.sort{|a,b| b.date <=> a.date}[0..amount]
        .map{|blog| include_template('homepage/blog.html', {'post' => blog})}.compact.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::BlogsFilters)