module Jekyll
  class PagedBlog < Page
    def initialize(site, base, dir, name, layout, data)
      self.data = data.clone
      self.data['layout'] = layout
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
      user_blogs = allblogs.clone
      create_all_blogs(site, allblogs)
      create_all_user_blogs(site, user_blogs)
    end

    private
    def create_all_blogs(site, allblogs)
      layout = 'allblogs'
      total = (allblogs.length / 15.to_f).ceil
      first_page_posts = allblogs.shift(15)
      site.pages << PagedBlog.new(site, site.source, '/blogs/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Blogs'
      })
      site.pages << PagedBlog.new(site, site.source, '/blogs/page_1/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Blogs'
      })
      current_page = 2
      while allblogs.size > 0
        site.pages << PagedBlog.new(site, site.source, "/blogs/page_#{current_page}/", 'index.html', layout, {
          'posts'  => allblogs.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Blogs'
        })
        current_page += 1
      end
    end

    def create_all_user_blogs(site, allblogs)
      layout = 'userblogs'
      users_blogs = Hash.new {|h,k| h[k] = []}
      allblogs.each do |post|
        users_blogs[post.categories[1]] << post
      end
      
      users_blogs.each do |user, blogs|
        user_name = user_to_name(user)
        base = "/blogs/#{user}/all/"
        total = (blogs.length / 15.to_f).ceil
        first_page_posts = blogs.shift(15)
        site.pages << PagedBlog.new(site, site.source, base, 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Blogs",
          'base' => base,
          'user' => user
        })
        site.pages << PagedBlog.new(site, site.source, "#{base}page_1/", 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Blogs",
          'base' => base,
          'user' => user
        })
        current_page = 2
        while blogs.size > 0
          site.pages << PagedBlog.new(site, site.source, "#{base}page_#{current_page}/", 'index.html', layout, {
            'posts'  => blogs.shift(15),
            'current_page' => current_page,
            'num_pages' => total,
            'title' => "#{user_name}'s Archived Blogs",
            'base' => base,
            'user' => user
          })
          current_page += 1
        end
      end
      
    end
    
    # Temporary reuse of code, this needs to be fixed
    private
    def user_to_name(author)
      capitalize_all(author.gsub(/_/,' '))
    end
    def capitalize_all(author)
      author.split(' ').collect{|x| x.capitalize}.join(' ')
    end
  end
end