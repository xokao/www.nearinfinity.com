module Jekyll
  class PagedTrainingCenterEvent < Page
    def initialize(site, base, dir, name, layout, data)
      self.data = data.clone
      self.data['layout'] = layout
      self.data['type'] = 'training_center_events'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class TrainingCenterEventsDataGenerator < Generator
    safe true

    def generate(site)
      all_events = site.posts.reject{|post| post.categories[0] != 'training_center_events' }.sort.reverse
      all_events.each do |post|
        post.data['layout'] = 'training_center_events'
      end
      
      layout = 'all_training_center_events'
      total = (all_events.length / 15.to_f).ceil
      first_page_posts = all_events.shift(15)
      site.pages << PagedTrainingCenterEvent.new(site, site.source, '/training_center_events/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Training Center Events'
      })
      site.pages << PagedTrainingCenterEvent.new(site, site.source, '/training_center_events/page_1/', 'index.html', layout, {
        'posts'  => first_page_posts,
        'current_page' => 1,
        'num_pages' => total,
        'title' => 'Recent Training Center Events'
      })
      current_page = 2
      while all_events.size > 0
        site.pages << PagedTrainingCenterEvent.new(site, site.source, "/training_center_events/page_#{current_page}/", 'index.html', layout, {
          'posts'  => all_events.shift(15),
          'current_page' => current_page,
          'num_pages' => total,
          'title' => 'Archived Training Center Events'
        })
        current_page += 1
      end
    end
  end
end