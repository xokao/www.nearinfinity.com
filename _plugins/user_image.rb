module Jekyll
  module AssetFilter
    def user_image(input)      
      "http://www.nearinfinity.com/assets/users/#{input}.png"
    end
  end
end