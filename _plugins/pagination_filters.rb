module Jekyll
  module PaginationFilters
    def paginate_tags(page)
      type = page['type']
      tag = page['tag_key']
      paginate(page, "tags/#{type}/#{tag}")
    end

    def paginate_user(page, url)
      url = url.split('/')[1..3].join('/')
      paginate(page, url)
    end

    def paginate(page, base_url)
      current_page = page['current_page']
      num_pages = page['num_pages']
      if num_pages > 1
        markup = "<div class='pagination'>"
        if current_page != 1
          markup += "<a href='/#{base_url}/page_1'>|&lt;</a>"
          markup += "<a href='/#{base_url}/page_#{current_page - 1}'>&lt;</a>"
        else
          markup += "<a href='#'>|&lt;</a><a href='#'>&lt;</a>"
        end

        low_page = [1,current_page - 3].max
        high_page = [num_pages,current_page + 3].min

        (low_page..high_page).each do |i|
          markup +="<a href='/#{base_url}/page_#{i}' "
          if current_page == i
            markup += "class='selected'"
          end
          markup +=">#{i}</a>"
        end
        
        if current_page != num_pages
          markup += "<a href='/#{base_url}/page_#{current_page + 1}'>&gt;</a>"
          markup += "<a href='/#{base_url}/page_#{num_pages}'>&gt;|</a>"
        else
          markup += "<a href='#'>&gt;</a><a href='#'>&gt;|</a>"
        end

        markup += '</div>'
      else
        ''
      end 
    end
  end
end

Liquid::Template.register_filter(Jekyll::PaginationFilters)