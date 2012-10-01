# Redirect code taken from http://www.marran.com/tech/creating-redirects-with-jekyll/

module Jekyll

  # The redirect page creates a simple page that refreshes a user from a URL alias to an existing post.
  # Redirects are only generated if there is a "redirects" and "source_url" parameter _config.yml
  
  class Redirects < Generator
    
    safe true
    priority :low

    def generate(site)
      generate_redirects(site) if (site.config['redirects'])    
    end

    def generate_redirects(site)
      site.pages.select{|x| x.data.key? 'redirects' and x.data.key? 'source_url' }.each do |p|
        p.data['redirects'].each do |r|
          redirect = RedirectPage.new(site, site.source, r, p.data['source_url'])
          redirect.render(site.layouts, site.site_payload)
          redirect.write(site.dest)
          site.pages << redirect
        end     
      end
    end

  end

  class RedirectPage < Page
    
    def initialize(site, base, path, destination)
      @site = site
      @base = base
      @dir  = path
      @name = 'index.html'
      self.process(@name)
      
      self.read_yaml(File.join(base, '_layouts'), 'redirect.html')
      self.data['source_url'] = destination
    end

  end
end