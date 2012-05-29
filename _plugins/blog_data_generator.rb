module Jekyll
  class PagedBlog < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'allblogs'
      self.data['type'] = 'blogs'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class BlogDataGenerator < Generator
    safe true

    def generate(site)
      allblogs = site.posts.reject{|post| post.categories[0] != 'blogs' }.sort.reverse
      allblogs.each do |post|
        post.data['layout'] = 'blogs'
      end

      total = (allblogs.length / 15.to_f).ceil
      first_page_posts = allblogs.shift(15)
      site.pages << PagedBlog.new(site, site.source, '/blogs/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Blogs'
      })
      site.pages << PagedBlog.new(site, site.source, '/blogs/page_1/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Blogs'
      })
      current_page = 2
      while allblogs.size > 0
        site.pages << PagedBlog.new(site, site.source, "/blogs/page_#{current_page}/", 'index.html', {
          'posts'  => allblogs.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Blogs'
        })
        current_page += 1
      end
    end
  end
end