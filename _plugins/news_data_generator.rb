module Jekyll
  class PagedNews < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'all_news'
      self.data['type'] = 'news'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class NewsDataGenerator < Generator
    safe true

    def generate(site)
      allnews = site.posts.reject{|post| post.categories[0] != 'news' }.sort.reverse
      allnews.each do |post|
        post.data['layout'] = 'news'
      end

      total = (allnews.length / 15.to_f).ceil
      first_page_posts = allnews.shift(15)
      site.pages << PagedNews.new(site, site.source, '/news/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent News'
      })
      site.pages << PagedNews.new(site, site.source, '/news/page_1/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent News'
      })
      current_page = 2
      while allnews.size > 0
        site.pages << PagedNews.new(site, site.source, "/news/page_#{current_page}/", 'index.html', {
          'posts'  => allnews.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived News'
        })
        current_page += 1
      end
    end
  end
end