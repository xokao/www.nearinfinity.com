module Jekyll
  module AssetFilters
    def user_image(input)  
      "/assets/images/users/#{input}.png"
    end

    def tag_link(tag, url = tag_url(tag), html_opts = nil)
      unless html_opts.nil?
        html_opts = ' ' + html_opts.map { |k, v| %Q{#{k}="#{v}"} }.join(' ')
      end
      %Q{<a href="#{url}"#{html_opts}>#{tag}</a>}
    end

    def tag_url(tag)
      "#{Tagger::TAG_PAGE_DIR + ERB::Util.u(tag)}#{'.html'}"
    end

    # Returns a comma seperated list off all tags for an object
    def tags(obj)
      tags = obj['tags'][0].is_a?(Array) ? obj['tags'].map{ |t| t[0] } : obj['tags']
      tags.map { |t| tag_link(t.downcase, tag_url(t)) if t.is_a?(String) }.compact.join(', ')
    end

    # Returns a list off all blog tags
    def tags_list(obj)
      obj['tags'].map { |tag_key, tag_value| "<li>#{tag_link(tag_key.downcase, tag_url(tag_key))}</li>" }.compact.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilters)