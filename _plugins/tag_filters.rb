module Jekyll
  module TagFilters
    # Returns a comma seperated list off all tags for a post
    def tags(post, page)
      type = page['type'] || page.categories[0]
      tags = post['tags'][0].is_a?(Array) ? post['tags'].map{ |t| t[0] } : post['tags']
      tags.sort.map { |t| "<a href='/tags/#{type}/#{t}.html'>#{t}</a>" if t.is_a?(String) }.compact.join(', ')
    end

    # Returns a list off all blog tags
    def tags_list(site, page)
      type = page['type'] || page.categories[0]
      site['tags'].sort.map { |tag_key, tag_value| "<li><a href='/tags/#{type}/#{tag_key}.html'>#{tag_key}</a></li>" }.compact.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagFilters)