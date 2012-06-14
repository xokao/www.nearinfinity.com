require 'nuggets/range/quantile'
require 'erb'
require './_plugins/tag_combiner.rb'

module Jekyll

  class Tagger < Generator
    safe true

    def generate(site)
      ['blogs', 'techtalks', 'speaking'].each do |type|
        site.tags.each do |tag, posts|
          filtered_posts = posts.reject{ |post| !post.categories.include? type }.sort.reverse
          next if filtered_posts.count <= 0
          total = (filtered_posts.length / 15.to_f).ceil
          first_page_posts = filtered_posts.shift(15)
          site.pages << new_tag(site, site.source, "tags/#{type}/#{tag}", tag, first_page_posts, 'tag_page', type, 1, total)
          site.pages << new_tag(site, site.source, "tags/#{type}/#{tag}/page_1", tag, first_page_posts, 'tag_page', type, 1, total)
          current_page = 2
          while filtered_posts.size > 0
            site.pages << new_tag(site, site.source, "tags/#{type}/#{tag}/page_#{current_page}", tag, filtered_posts.shift(15), 'tag_page', type, current_page, total)
            current_page += 1
          end
        end
      end
    end

    def new_tag(site, base, dir, tag, posts, layout, type, current, total)
      TagPage.new(site, base, dir, "index#{site.layouts[layout].ext}", {
        'layout' => layout,
        'posts'  => posts,
        'type'   => type,
        'tag_key'=> tag,
        'current_page' => current,
        'num_pages' => total
      })
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, name, data = {})
      self.content = data.delete('content') || ''
      self.data    = data

      dir = dir[-1, 1] == '/' ? dir : '/' + dir

      super(site, base, dir, name)

      self.data['tag'] = basename
    end

    def read_yaml(_, __)
      # Do nothing
    end
  end
end
