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

    class ExcerptRssFeed < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'excerpt_rss_feed'
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

      create_blog_feeds(site, site.source, '/blogs/', {
        'posts'  => allblogs,
        'title' => "Blogs at Near Infinity",
        'link' => "http://www.nearinfinity.com/blogs",
        'description' => 'Employee Blogs'
      })

      # Generate the Authors Feeds
      sorted_blogs.each do |author, author_posts|
        formatted_author = author.split('_').collect{|x| x.capitalize}.join(' ')
        create_blog_feeds(site, site.source, "/blogs/#{author}/rss/", {
          'posts'  => author_posts,
          'title' => "#{formatted_author} - Blogs at Near Infinity",
          'link' => "http://www.nearinfinity.com/blogs/#{author}",
          'description' => "#{formatted_author}'s Blogs"
        })
      end

      # Generate the Tags Feeds
      site.tags.each do |tag, tag_posts|
        filtered_posts = tag_posts.reject{ |post| !post.categories.include? 'blogs' }.sort.reverse
        create_blog_feeds(site, site.source, "/blogs/#{tag}/rss/", {
          'posts'  => filtered_posts,
          'title' => "#{tag.capitalize} Related Blogs - Blogs at Near Infinity",
          'link' => "http://www.nearinfinity.com/tags/blogs/#{tag}",
          'description' => "#{tag.capitalize} Blogs"
        })
      end
      
      create_all_post_feeds(site)
      
      create_news_feeds(site)
    end

    def create_blog_feeds(site, base, dir, data)
      site.pages << RssFeed.new(site, base, dir, "index.xml", data)
      site.pages << AtomFeed.new(site, base, dir, "atom.xml", data)
      site.pages << ExcerptRssFeed.new(site, base, dir, "blogs.xml", data)
    end
    
    def create_all_post_feeds(site)
      data = {
        'posts' => site.posts.sort.reverse,
        'title' => 'Near Infinity',
        'link' => 'http://www.nearinfinity.com',
        'description' => 'Near Infinity Posts'
      }
      site.pages << RssFeed.new(site, site.source, '/', 'index.xml', data)
      site.pages << AtomFeed.new(site, site.source, '/', 'atom.xml', data)
      site.pages << ExcerptRssFeed.new(site, site.source, '/', 'excerpt.xml', data)
    end
    
    def create_news_feeds(site)
      data = {
        'posts' => site.posts.reject{|post| post.categories[0] != 'news' }.sort.reverse,
        'title' => 'Near Infinity News',
        'link' => 'http://www.nearinfinity.com/news',
        'description' => 'Near Infinity News'
      }
      site.pages << RssFeed.new(site, site.source, '/news/', 'index.xml', data)
      site.pages << AtomFeed.new(site, site.source, '/news/', 'atom.xml', data)
      site.pages << ExcerptRssFeed.new(site, site.source, '/news/', 'excerpt.xml', data)
    end
  end
end