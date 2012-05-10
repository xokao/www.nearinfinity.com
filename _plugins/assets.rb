module Jekyll
  module AssetFilters
    # Returns a users image url
    def user_image(input)  
      "/assets/images/users/#{input}.png"
    end

    # Returns a list of all authors
    def authors_list(site, sort = true)
      authors = site['categories'].keys.reject {|category|
        ['blogs', 'techtalks', 'news', 'speaking'].include? category
      }.sort
      authors.map { |author| "<li><a href='#{author_url(author)}' class='author-filter'>#{author.gsub('_', ' ')}</a></li>" }.compact.join
    end

    def author_url(author)
      "/blogs/#{author}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilters)