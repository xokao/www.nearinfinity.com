module Jekyll
  module TagFilters
    # Returns a comma seperated list off all tags for a post
    def tags(post, page)
      type =page['type'] || page['url'].split('/')[1]
      tags = post['tags'][0].is_a?(Array) ? post['tags'].map{ |t| t[0] } : post['tags']
      tags.sort.map { |t| "<a href='/tags/#{type}/#{t.downcase}'>#{t.downcase}</a>" if t.is_a?(String) }.compact.join(', ')
    end

    # Returns a list off all blog tags
    def tags_list(site, page)
      type =page['type'] || page['url'].split('/')[1]
      site['tags'].map{ |tag_key, tag_value| "<li><a href='/tags/#{type}/#{tag_key.downcase}/'>#{tag_key.downcase}</a></li>" }.uniq.sort.compact.join
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
        markup += "<li><a href='/tags/#{type}/#{tag}/'>View All</a></li>"
        markup
      else
        ''
      end
    end

    private
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

Liquid::Template.register_filter(Jekyll::TagFilters)