module Jekyll
  class PagedPublishedWorks < Page
    def initialize(site, base, dir, name, layout, data)
      self.data = data.clone
      self.data['layout'] = layout
      self.data['type'] = 'published_works'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class PublishedWorksDataGenerator < Generator
    safe true

    def generate(site)
      all_published_works = site.posts.reject{|post| post.categories[0] != 'published_works' }.sort.reverse
      all_published_works.each do |post|
        post.data['layout'] = 'published_works'
      end
      user_published_works = all_published_works.clone
      create_all_published_works(site, all_published_works)
      create_all_user_published_works(site, user_published_works)
    end

    private

    def create_all_published_works(site, all_published_works)
      layout = 'all_published_works'
      total = (all_published_works.length / 15.to_f).ceil
      first_page_posts = all_published_works.shift(15)
      site.pages << PagedPublishedWorks.new(site, site.source, '/published_works/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Published Works'
      })
      site.pages << PagedPublishedWorks.new(site, site.source, '/published_works/page_1/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Published Works'
      })
      current_page = 2
      while all_published_works.size > 0
        site.pages << PagedPublishedWorks.new(site, site.source, "/published_works/page_#{current_page}/", 'index.html', layout, {
          'posts'  => all_published_works.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Published Works'
        })
        current_page += 1
      end
    end

    def create_all_user_published_works(site, all_published_works)
      layout = 'user_published_works'
      users_published_works = Hash.new {|h,k| h[k] = []}
      all_published_works.each do |post|
        users_published_works[post.categories[1]] << post
      end

      users_published_works.each do |user, published_works|
        user_name = user_to_name(user)
        base = "/published_works/#{user}/all/"
        total = (published_works.length / 15.to_f).ceil
        first_page_posts = published_works.shift(15)
        site.pages << PagedPublishedWorks.new(site, site.source, base, 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Published Works",
          'base' => base,
          'user' => user
        })
        site.pages << PagedPublishedWorks.new(site, site.source, "#{base}page_1/", 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Published Works",
          'base' => base,
          'user' => user
        })
        current_page = 2
        while published_works.size > 0
          site.pages << PagedPublishedWorks.new(site, site.source, "#{base}page_#{current_page}/", 'index.html', layout, {
            'posts'  => published_works.shift(15),
            'current_page' => current_page,
            'num_pages' => total,
            'title' => "#{user_name}'s Archived Published Works",
            'base' => base,
            'user' => user
          })
          current_page += 1
        end
      end
    end

    # Temporary reuse of code, this needs to be fixed
    def user_to_name(author)
      capitalize_all(author.gsub(/_/,' '))
    end
    def capitalize_all(author)
      author.split(' ').collect{|x| x.capitalize}.join(' ')
    end
  end
end