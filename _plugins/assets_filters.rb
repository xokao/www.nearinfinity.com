module Jekyll
  module AssetFilters
    # Returns a users image url
    def user_image(site, user, class_name="")
      if employee_number = site['pages'].select{|page| page.instance_variable_get('@dir').end_with? user}.first.data['employee_number']
        "<img class='#{class_name}' src='http://www.nearinfinity.com/images/vector_art_circle/#{employee_number}.png' username='#{user}' />"
      else
        puts "User image not found for #{user}"
        ""
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilters)