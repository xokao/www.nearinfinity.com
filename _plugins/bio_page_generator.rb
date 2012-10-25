require 'json'

module Jekyll
  class ShortBioPage < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'short_bio'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class EmployeeMapPage < Page
    def initialize(site, base, dir, name, data)
      self.data = data.clone
      self.data['layout'] = 'employee_map'
      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing, Allows you to make pages that dont have pages at the location they are built in
    end
  end

  class BioGenerator < Generator
    safe true

    def generate(site)
      employees = []
      site.pages.each do |page|
        directory_parse = page.instance_variable_get('@dir').split('/')
        next if !bio_sub_directory? directory_parse
        page.data.merge!({'layout' => 'person', 'user' => directory_parse.last})
        employees << page
        site.pages << ShortBioPage.new(site, site.source, '/short_bios/popup_bio/', "#{page.data['user']}.html", page.data)
      end

      data = {
        "employees" => employees.map{|page| {
          'employee_number' => page.data['employee_number'],
          'blog_name' => page.data['user']
        }}.to_json
      }

      site.pages << EmployeeMapPage.new(site, site.source, '/', "employee_map.json", data)
    end

    private
    def bio_sub_directory?(dir_parse)
      return true if dir_parse.include? 'blogs' and dir_parse.length > 2
      return true if dir_parse.include? 'who_we_are' and dir_parse.include? 'bios'
      return false
    end
  end
end