module Jekyll
  class WhiteListPage < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'white_list'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class WhiteListGenerator < Generator
    safe true

    def generate(site)
      names = Dir.entries('who_we_are/bios').reject{|author| author.match(/^\./)}
      list = names.collect! { |name| "'" + name + "'"}.join(',')
      site.pages << WhiteListPage.new(site, site.source, '/assets/js/', 'white_list.js', {'names' => list})
    end
  end
end