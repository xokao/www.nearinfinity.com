module Jekyll
  module ContentFilters
    def recent_blogs_list

    end

    def future_speaking_engagements

    end

    def recent_techtalks_list

    end
  end
end

Liquid::Template.register_filter(Jekyll::ContentFilters)