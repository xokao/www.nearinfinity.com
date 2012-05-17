module Jekyll
  class ShortBioPage < Page
    def initialize(site, base, dir, name, data)
      self.data = data
      self.data['layout'] = 'short_bio'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class BioGenerator < Generator
    safe true
    
    def generate(site)
      bio_pages = site.pages.reject{ |page| page.data['short_bio'].nil? }.each do |page|
        site.pages << ShortBioPage.new(site, site.source, '/short_bios/popup_bio/', "#{page.data['user']}.html", page.data)
      end
    end
  end
end