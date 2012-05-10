module Jekyll
  module AssetFilters
    # Returns a users image url
    def user_image(input)  
      "/assets/images/users/#{input}.png"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilters)