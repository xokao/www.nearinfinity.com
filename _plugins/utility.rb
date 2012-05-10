module Jekyll
  module UtilityFilters
    #capitalize all words in a string, IE names
    def capitalize_all(author)
      author.split(' ').collect{|x| x.capitalize}.join(' ')
    end

    #takes in username with underscore, returns pretty name
    def user_to_name(author)
      capitalize_all(author.gsub(/_/,' '))
    end

    #takes in page finds author and return pretty name
    def page_to_user(page)
      author = page['user'] || page['categories'][1]
      user_to_name author
    end

    #returns the word at the index provided from the input string
    def nth_word(string, index)
      string.split(' ')[index]
    end

    def excerpt(page, num_words=20)
      if page.has_key?('exerpt')
        page.exerpt
      else
        page['content'].gsub(/<[^>]*>/,'').split(' ').slice(0,num_words).join(' ') + '...'
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::UtilityFilters)