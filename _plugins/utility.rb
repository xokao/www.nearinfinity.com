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
      user_to_name find_user(page)
    end

    def find_user(page)
      page['user'] || page['categories'][1]
    end

    #returns the word at the index provided from the input string
    def nth_word(string, index)
      string.split(' ')[index]
    end

    def excerpt(page, num_words=20)
      if page.has_key?('excerpt')
        page['excerpt']
      else
        page['content'].gsub(/<[^>]*>/,'').split(' ').slice(0,num_words).join(' ') + '...'
      end
    end

    def type_to_human(type)
      translate = {'blogs' => 'BLOGS', 'techtalks' => 'TECHTALKS', 'speaking' => 'SPEAKING ENGAGEMENTS'}
      translate[type]
    end
  end

  class IncludeMarkdownTag < Liquid::Tag
    def initialize(tag_name, template, tokens)
      super
      @template = template
    end

    def render(context)
      input = Jekyll::IncludeTag.new(nil, @template, nil).render(context).lstrip
      site = context.registers[:site]
      converter = site.getConverterImpl(Jekyll::MarkdownConverter)
      converter.convert(input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::UtilityFilters)
Liquid::Template.register_tag('include_markdown', Jekyll::IncludeMarkdownTag)