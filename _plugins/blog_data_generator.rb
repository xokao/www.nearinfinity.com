module Jekyll

  class BlogDataGenerator < Generator
    safe true

    def generate(site)
      site.posts.reject{|post| post.categories[0] != 'blogs' }.each do |post|
        post.data['layout'] = 'blogs'
      end
    end
  end
end