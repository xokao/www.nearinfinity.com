begin
  require 'less'

  module Jekyll
    module Less

      class LessCssFile < Jekyll::StaticFile
        require 'colorize'
        @@already_generated = false

        # Obtain destination path.
        #   +dest+ is the String path to the destination dir
        #
        # Returns destination file path.
        def destination(dest)
          File.join(dest, "assets", "css", "style.css")
        end

        def self.reset
          @@already_generated = false
        end

        # Convert the less file into a css file.
        #   +dest+ is the String path to the destination dir
        #
        # Returns false if the file was not modified since last time (no-op).
        def write(dest)
          dest_path = File.join @base, '_site', 'assets', 'css', 'style.css'
          return false if File.exist? dest_path and !modified?
          return false if @@already_generated
          @@mtimes[path] = mtime

          FileUtils.mkdir_p(File.dirname(dest_path))
          begin
            path = File.join @base, 'assets', 'less', 'style.less'
            content = File.read(path)
            content = ::Less::Parser.new({:paths => [File.dirname(path)]}).parse(content).to_css
            File.open(dest_path, 'w') do |f|
              f.write(content)
            end
            puts "[SUCCESS] Less generated successfully".green
          rescue => e
            puts "[ ERROR ] Less Exception: #{e.message}".red
          end

          @@already_generated = true
        end

      end

      class LessCssGenerator < Jekyll::Generator
        safe true

        # Jekyll will have already added the *.less files as Jekyll::StaticFile
        # objects to the static_files array.  Here we replace those with a
        # LessCssFile object.
        def generate(site)
          LessCssFile.reset

          site.static_files.clone.each do |sf|
            if sf.kind_of?(Jekyll::StaticFile)

              if sf.path =~ /css\/style.css$/
                # Remove this if will be generated
                site.static_files.delete(sf)

              elsif sf.path =~ /\.less$/
                # Replace with less css file`
                site.static_files.delete(sf)
                name = File.basename(sf.path)
                destination = File.dirname(sf.path).sub(site.source, '')
                site.static_files << LessCssFile.new(site, site.source, destination, name)
              end
            end
          end
        end
      end

    end
  end
rescue LoadError
  puts "Skipping less compilation on windows"
end
