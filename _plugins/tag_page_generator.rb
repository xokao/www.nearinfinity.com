require 'nuggets/range/quantile'
require 'erb'

module Jekyll

  class Tagger < Generator
    safe true

    def generate(site)
      %w[TAG_PAGE_DIR TAG_FEED_DIR].each do |dir_name|
        Tagger.const_set(dir_name, site.config[dir_name.downcase] || 'tag') unless Tagger.const_defined?(dir_name.to_sym)
      end

      @tag_page_layout = site.config['tag_page_layout']

      Jekyll::Filters.const_set('PRETTY_URL', site.permalink_style == :pretty) unless Jekyll::Filters.const_defined?(:PRETTY_URL)

      if @tag_page_layout
        generate_tag_pages(site)
      else
        warn 'WARNING: You have to define a tag_page_layout in configuration file.'
      end
    end

    # Generates a page per tag and adds them to all the pages of +site+.
    # A <tt>tag_page_layout</tt> have to be defined in your <tt>_config.yml</tt>
    # to use this.
    def generate_tag_pages(site)
      ['blogs', 'techtalks', 'speaking'].each do |type|
        site.tags.each do |tag, posts|
          filtered_posts = posts.reject{ |post| !post.categories.include? type }
          site.pages << new_tag(site, site.source, "#{TAG_PAGE_DIR}/#{type}", tag, filtered_posts.sort.reverse, @tag_page_layout)
        end
      end
    end

    def new_tag(site, base, dir, tag, posts, layout)
      TagPage.new(site, base, dir, "#{tag}#{site.layouts[layout].ext}", {
        'layout' => layout,
        'posts'  => posts,
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