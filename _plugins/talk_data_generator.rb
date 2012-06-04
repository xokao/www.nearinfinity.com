module Jekyll
  class PagedTalk < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'allblogs'
      self.data['type'] = 'techtalks'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class TalkDataGenerator < Generator
    safe true

    def generate(site)
      alltalks = site.posts.reject{|post| post.categories[0] != 'techtalks' }.sort.reverse
      alltalks.each do |post|
        post.data['layout'] = 'techtalks'
      end

      total = (alltalks.length / 15.to_f).ceil
      first_page_posts = alltalks.shift(15)
      site.pages << PagedTalk.new(site, site.source, '/techtalks/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Tech Talks'
      })
      site.pages << PagedTalk.new(site, site.source, '/techtalks/page_1/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Tech Talks'
      })
      current_page = 2
      while alltalks.size > 0
        site.pages << PagedTalk.new(site, site.source, "/techtalks/page_#{current_page}/", 'index.html', {
          'posts'  => alltalks.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Tech Talks'
        })
        current_page += 1
      end
    end
  end
end