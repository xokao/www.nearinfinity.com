module Jekyll
  class PagedSpeaking < Page
    def initialize(site, base, dir, name, layout, data)
      self.data = data.clone
      self.data['layout'] = layout
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
      user_speaking = allspeaking.clone
      create_all_speaking(site, allspeaking)
      create_all_user_speaking(site, user_speaking)
    end

    private

    def create_all_speaking(site, allspeaking)
      layout = 'allspeaking'
      total = (allspeaking.length / 15.to_f).ceil
      first_page_posts = allspeaking.shift(15)
      site.pages << PagedSpeaking.new(site, site.source, '/speaking/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Speaking Engagements'
      })
      site.pages << PagedSpeaking.new(site, site.source, '/speaking/page_1/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Speaking Engagements'
      })
      current_page = 2
      while allspeaking.size > 0
        site.pages << PagedSpeaking.new(site, site.source, "/speaking/page_#{current_page}/", 'index.html', layout, {
          'posts'  => allspeaking.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Speaking'
        })
        current_page += 1
      end
    end

    def create_all_user_speaking(site, allspeaking)
      layout = 'userspeaking'
      users_speaking = Hash.new {|h,k| h[k] = []}
      allspeaking.each do |post|
        users_speaking[post.categories[1]] << post
      end

      users_speaking.each do |user, speaking|
        user_name = user_to_name(user)
        base = "/speaking/#{user}/all/"
        total = (speaking.length / 15.to_f).ceil
        first_page_posts = speaking.shift(15)
        site.pages << PagedSpeaking.new(site, site.source, base, 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Speaking Engagements",
          'base' => base,
          'user' => user
        })
        site.pages << PagedSpeaking.new(site, site.source, "#{base}page_1/", 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Speaking Engagements",
          'base' => base,
          'user' => user
        })
        current_page = 2
        while speaking.size > 0
          site.pages << PagedSpeaking.new(site, site.source, "#{base}page_#{current_page}/", 'index.html', layout, {
            'posts'  => speaking.shift(15),
            'current_page' => current_page,
            'num_pages' => total,
            'title' => "#{user_name}'s Archived Speaking Engagements",
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