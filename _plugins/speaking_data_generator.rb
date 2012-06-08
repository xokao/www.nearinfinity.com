module Jekyll
  class PagedSpeaking < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'allspeaking'
      self.data['type'] = 'speaking'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class SpeakingDataGenerator < Generator
    safe true

    def generate(site)
      allspeaking = site.posts.reject{|post| post.categories[0] != 'speaking' }.sort.reverse
      allspeaking.each do |post|
        post.data['layout'] = 'speaking'
      end

      total = (allspeaking.length / 15.to_f).ceil
      first_page_posts = allspeaking.shift(15)
      site.pages << PagedSpeaking.new(site, site.source, '/speaking/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Speaking Engagements'
      })
      site.pages << PagedSpeaking.new(site, site.source, '/speaking/page_1/', 'index.html', {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Speaking Engagements'
      })
      current_page = 2
      while allspeaking.size > 0
        site.pages << PagedSpeaking.new(site, site.source, "/speaking/page_#{current_page}/", 'index.html', {
          'posts'  => allspeaking.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Speaking'
        })
        current_page += 1
      end
    end
  end
end