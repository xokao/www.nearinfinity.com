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
      authors.map { |author| "<li><a href='#{author_url(author)}' class='author-filter'>#{user_to_name(author)}</a></li>" }.compact.join
    end

    def author_url(author)
      "/blogs/#{author}"
    end

    #capitalize all words in a string, IE names
    def capitalize_all(input)
      input.split(' ').collect{|x| x.capitalize}.join(' ')
    end

    #takes in username with underscore, returns pretty name
    def user_to_name(input)
      capitalize_all(input.gsub(/_/,' '))
    end

    #returns the word at the index provided from the input string
    def nth_word(input,index)
      input.split(' ')[index]
    end

  end
end

Liquid::Template.register_filter(Jekyll::AssetFilters)