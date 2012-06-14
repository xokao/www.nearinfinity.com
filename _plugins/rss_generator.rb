require './_plugins/tag_combiner.rb'

module Jekyll
  class RssFeed < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'rss_feed'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class AtomFeed < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'atom_feed'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class RssFeedGenerator < Generator
    safe true

    def generate(site)
      allblogs = site.posts.reject{|post| post.categories[0] != 'blogs' }.sort.reverse
      sorted_blogs = {}

      allblogs.each do |post|
        selected_user = sorted_blogs[post.categories[1]] ||= []
        selected_user << post
      end

      create_feeds(site, site.source, '/blogs/', {
        'posts'  => allblogs,
        'title' => "Blogs at Near Infinity",
        'link' => "http://www.nearinfinity.com/blogs",
        'description' => 'Employee Blogs'
      })

      # Generate the Authors Feeds
      sorted_blogs.each do |author, author_posts|
        formatted_author = author.split('_').collect{|x| x.capitalize}.join(' ')
        create_feeds(site, site.source, "/blogs/#{author}/rss/", {
          'posts'  => author_posts,
          'title' => "#{formatted_author} - Blogs at Near Infinity",
          'link' => "http://www.nearinfinity.com/blogs/#{author}",
          'description' => "#{formatted_author}'s Blogs"
        })
      end

      # Generate the Tags Feeds
      site.tags.each do |tag, tag_posts|
        filtered_posts = tag_posts.reject{ |post| !post.categories.include? 'blogs' }.sort.reverse
        create_feeds(site, site.source, "/blogs/#{tag}/rss/", {
          'posts'  => filtered_posts,
          'title' => "#{tag.capitalize} Related Blogs - Blogs at Near Infinity",
          'link' => "http://www.nearinfinity.com/tags/blogs/#{tag}",
          'description' => "#{tag.capitalize} Blogs"
        })
      end
    end

    def create_feeds(site, base, dir, data)
      site.pages << RssFeed.new(site, base, dir, "blogs.xml", data)
      site.pages << RssFeed.new(site, base, dir, "index.xml", data)
      site.pages << AtomFeed.new(site, base, dir, "atom.xml", data)
    end
  end
end