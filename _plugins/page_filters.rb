module Jekyll
  module BlogsFilters
    def render_homepage_posts(amount,type,template)
      all_blogs = @context.registers[:site].categories[type]
      hiddenIds = @context.registers[:site].config['hideFromHomepage']
      filtered_blogs = all_blogs.reject{ |blog| hiddenIds.include? blog.id }
      filtered_blogs.sort{|a,b| b.date <=> a.date}[0..(amount - 1)]
        .map{|blog| include_template(template, {'post' => blog})}.compact.join
    end

    # Render the short blog partial for the home page
    def render_homepage_blogs(amount)
      render_homepage_posts(amount,'blogs','homepage/blog.html')
    end

    # Render the short techtalks partial for the home page
    def render_homepage_techtalks(amount)
      render_homepage_posts(amount,'techtalks','homepage/techtalk.html')
    end

    # Render the short speaking partial for the home page
    def render_homepage_speaking(amount)
      render_homepage_posts(amount,'speaking','homepage/speaking.html')
    end

    def blog_with_similar_tags(blog, count = 5)
      return if blog['tags'].count == 0
      similarity_index = create_similarity_index blog, @context.registers[:site].categories['blogs']
      limited_related_blogs = create_most_related_array similarity_index
      limited_related_blogs[0..count].map{ |post|
        "<li>#{include_template('post-list-item.html', {'post' => post})}</li>"
      }.compact.join
    end

    private
    def create_similarity_index(blog, all_blogs)
      similarity_index = {}
      all_blogs.each do |compared_blog|
        next if compared_blog.id == blog['id']
        similarity = (blog['tags'] & compared_blog.tags).length
        similarity_index[similarity] = [] unless similarity_index.has_key? similarity
        similarity_index[similarity] << compared_blog
      end
      # Remove the unrelated posts (efficiency)
      similarity_index.delete 0
      similarity_index.each{|key, blog_list| blog_list.sort!{|a,b| b.date <=> a.date}}
    end

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