module Jekyll
  module AssetFilters
    # Returns a users image url
    def user_image(user, site)
      if employee_number = site['pages'].select{|page| page.name and page.name.start_with? user}.first.data['employee_number']
        "/assets/images/users/#{employee_number}.png"
      else
        puts "User image not found for #{user}"
        ""
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilters)