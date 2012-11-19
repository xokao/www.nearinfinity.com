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

  class NicPlusRssFeed < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'nicplus_rss_feed'
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
      create_all_post_feeds(site)
      create_all_blog_feeds(site)
      create_news_feeds(site)
      create_tech_talk_feeds(site)
      create_speaking_engagement_feeds(site)
      create_published_works_feeds(site)
      create_training_center_events_feeds(site)
    end
    
    def create_all_post_feeds(site)
      create_feeds(site, '/', 'excerpt.xml', {
        'posts' => site.posts.sort.reverse,
        'title' => 'Near Infinity',
        'link' => 'http://www.nearinfinity.com',
        'description' => 'Near Infinity News, Blogs, Tech Talks, Published Works and Speaking Engagements'
      })
    end
    
    def create_all_blog_feeds(site)
      allblogs = site.posts.reject{|post| post.categories[0] != 'blogs' }.sort.reverse
      
      create_feeds(site, '/blogs/', 'blogs.xml', {
        'posts'  => allblogs,
        'title' => "Blogs at Near Infinity",
        'link' => "http://www.nearinfinity.com/blogs",
        'description' => 'Employee Blogs'
      })

      site.pages << NicPlusRssFeed.new(site, site.source, '/blogs/', 'nicplus_feed.xml', {
        'posts'  => allblogs,
        'title' => "NIC+ Feed",
        'link' => "http://www.nearinfinity.com/blogs",
        'description' => 'Nic+ Feed'
      })
      
      # Generate the Authors Feeds
      sorted_blogs = Hash.new {|h,k| h[k] = []}
      allblogs.each do |post|
        sorted_blogs[post.categories[1]] << post
      end

      sorted_blogs.each do |author, author_posts|
        formatted_author = author.split('_').collect{|x| x.capitalize}.join(' ')
        create_feeds(site, "/blogs/#{author}/rss/", 'blogs.xml', {
          'posts'  => author_posts,
          'title' => "#{formatted_author} - Blogs at Near Infinity",
          'link' => "http://www.nearinfinity.com/blogs/#{author}",
          'description' => "#{formatted_author}'s Blogs"
        })
      end

      # Generate the Tags Feeds
      site.tags.each do |tag, tag_posts|
        filtered_posts = tag_posts.reject{ |post| !post.categories.include? 'blogs' }.sort.reverse
        create_feeds(site, "/blogs/#{tag}/rss/", 'blogs.xml', {
          'posts'  => filtered_posts,
          'title' => "#{tag.capitalize} Related Blogs - Blogs at Near Infinity",
          'link' => "http://www.nearinfinity.com/tags/blogs/#{tag}",
          'description' => "#{tag.capitalize} Blogs"
        })
      end
    end
    
    def create_news_feeds(site)
      data = {
        'posts' => site.posts.reject{|post| !post.categories.include? 'news' }.sort.reverse,
        'title' => 'Near Infinity News',
        'link' => 'http://www.nearinfinity.com/news',
        'description' => 'Recent news stories regarding Near Infinity'
      }
      create_feeds(site, '/news/', 'news.xml', data)
      
      # Copying xml file to url from old website
      site.pages << ExcerptRssFeed.new(site, site.source, '/blogs/', 'news.xml', data)
    end
    
    def create_tech_talk_feeds(site)
      create_feeds(site, '/techtalks/', 'tech_talks.xml', {
        'posts' => site.posts.reject{|post| !post.categories.include? 'techtalks' }.sort.reverse,
        'title' => 'Near Infinity Tech Talks',
        'link' => 'http://www.nearinfinity.com/techtalks',
        'description' => 'Near Infinity Tech Talks'
      })
    end
    
    def create_speaking_engagement_feeds(site)
      create_feeds(site, '/speaking/', 'speaking_engagements.xml', {
        'posts' => site.posts.reject{|post| !post.categories.include? 'speaking' }.sort.reverse,
        'title' => 'Near Infinity Speaking Engagements',
        'link' => 'http://www.nearinfinity.com/speaking',
        'description' => 'Near Infinity Speaking Engagements'
      })
    end
    
    def create_published_works_feeds(site)
      create_feeds(site, '/published_works/', 'published_works.xml', {
        'posts' => site.posts.reject{|post| !post.categories.include? 'published_works' }.sort.reverse,
        'title' => 'Near Infinity Published Works',
        'link' => 'http://www.nearinfinity.com/published_works',
        'description' => 'Near Infinity Published Works'
      })
    end
    
    def create_training_center_events_feeds(site)
      create_feeds(site, '/training_center_events/', 'training_center_events.xml', {
        'posts' => site.posts.reject{|post| !post.categories.include? 'training_center_events' }.sort.reverse,
        'title' => 'Near Infinity Training Center Events',
        'link' => 'http://www.nearinfinity.com/training_center_events',
        'description' => "Events held at Near Infinity's training center"
      })
    end
    
    def create_feeds(site, base, excerpt_file_name, data)
      site.pages << RssFeed.new(site, site.source, base, 'index.xml', data)
      site.pages << AtomFeed.new(site, site.source, base, 'atom.xml', data)
      site.pages << ExcerptRssFeed.new(site, site.source, base, excerpt_file_name, data)
    end
  end
end