module Jekyll
  class PagedTalk < Page
    def initialize(site, base, dir, name, layout, data)
      self.data = data.clone
      self.data['layout'] = layout
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
      user_talks = alltalks.clone
      create_all_techtalks(site, alltalks)
      create_all_user_techtalks(site, user_talks)
    end

    private

    def create_all_techtalks(site, alltalks)
      layout = 'all_dynamic_posts'
      total = (alltalks.length / 15.to_f).ceil
      first_page_posts = alltalks.shift(15)
      site.pages << PagedTalk.new(site, site.source, '/techtalks/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Tech Talks'
      })
      site.pages << PagedTalk.new(site, site.source, '/techtalks/page_1/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Tech Talks'
      })
      current_page = 2
      while alltalks.size > 0
        site.pages << PagedTalk.new(site, site.source, "/techtalks/page_#{current_page}/", 'index.html', layout, {
          'posts'  => alltalks.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Tech Talks'
        })
        current_page += 1
      end
    end

    def create_all_user_techtalks(site, alltalks)
      layout = 'usertechtalks'
      users_talks = Hash.new {|h,k| h[k] = []}
      alltalks.each do |post|
        users_talks[post.categories[1]] << post
      end

      users_talks.each do |user, talks|
        user_name = user_to_name(user)
        base = "/techtalks/#{user}/all/"
        total = (talks.length / 15.to_f).ceil
        first_page_posts = talks.shift(15)
        site.pages << PagedTalk.new(site, site.source, base, 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Techtalks",
          'base' => base,
          'user' => user
        })
        site.pages << PagedTalk.new(site, site.source, "#{base}page_1/", 'index.html', layout, {
          'posts'  => first_page_posts,
          'current_page' => 1,
          'num_pages' => total,
          'title' => "#{user_name}'s Recent Techtalks",
          'base' => base,
          'user' => user
        })
        current_page = 2
        while talks.size > 0
          site.pages << PagedTalk.new(site, site.source, "#{base}page_#{current_page}/", 'index.html', layout, {
            'posts'  => talks.shift(15),
            'current_page' => current_page,
            'num_pages' => total,
            'title' => "#{user_name}'s Archived Techtalks",
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