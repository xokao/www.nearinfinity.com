NIC Website
===========


Setup Repository
----------------

```
# Clone repo and blogs submodule
git clone --recursive git@github.com:nearinfinity/www.nearinfinity.com.git
cd nearinfinity.github.com/blogs    
git checkout master

# Change the remote URL to read/write. gh-pages requires the submodule to be read-only
git remote set-url origin git@github.com:nearinfinity/blogs.nearinfinity.com.git
```

Prequisites 
-----------

* ruby 1.9 (jekyll preview)
* python (syntax highlighter)

```
[sudo] gem install bundler
[sudo] easy_install Pygments
bundle install
```

Server
------

    rake server        # slower, shows all posts
    rake server:recent # faster, shows recent

This will run a server on <http://localhost:4000> that regenerates any changes


Syntax Highlighting
-------------------

    {% highlight <language> [linenos] %}
    def to_s
      "#{name}"
    end
    {% endhighlight %}

View list of languages

    > pygmentize -L

Embed Videos
------------

    {% video_tag :vimeo => [video_id] %}
    {% video_tag :youtube => [unique_id] %}


Business Design Goals
---------------------
* Tailor to an audience other than developers

Technical Design Goals
----------------------
* Responsive from 320 to ~1600
    * iOS, Android, Desktop
* Clean URLS where possible, link/index.html instead of link.html
* Performant
    * Zepto for modern browsers, jquery for IE
    * Data URIS for background textures
    * Animations with CSS, minimize JS
* Sharing links instead of iframes (don't let others track our users)
    * Disqus (for comments) being the only exception
* Browser Support
    * IE6-8 is usable
    * A-Grade browsers: Safari, Chrome, Firefox, IE 9+ 
* Consistent blog highlighting, video embedding


