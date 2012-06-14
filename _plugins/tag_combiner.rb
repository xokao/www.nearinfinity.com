module Jekyll
  class TagGenerator < Generator
    safe true

    def generate(site)
      sorted_tags = {}
      site.tags.each do |tag, posts|
        sorted_tags[tag.downcase] ||= []
        sorted_tags[tag.downcase].concat posts
        sorted_tags[tag.downcase].flatten!
      end
      site.tags = sorted_tags
    end
  end
end