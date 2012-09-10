NIC Website
===========


Setup Repository
----------------

    # Clone repo and blogs submodule
    git clone --recursive git@github.com:nearinfinity/www.nearinfinity.com.git
    cd www.nearinfinity.com/blogs    
    git checkout master
    
    # Change the remote URL to read/write. gh-pages requires the submodule to be read-only
    git remote set-url origin git@github.com:nearinfinity/blogs.nearinfinity.com.git

Prequisites 
-----------

* ruby 1.9 (jekyll preview)
* python (syntax highlighter)

```
[sudo] gem install bundler
[sudo] easy_install Pygments
bundle
```

Unix Systems
-----------

If you are on a unix based system (mac, ubuntu, etc.), you will need to install
the header files for compiling extension modules for ruby 1.9.1.

```
[sudo] apt-get install ruby1.9.1-dev
```

Compiling The Site
-----------------

  rake jekyll # Cannot be run from the blogs directory

This will manually compile the site

Server
------

    rake server        # slower, shows all posts
    rake server:recent # faster, shows recent

This will run a server on <http://localhost:4000> that regenerates any changes

Creating a blog
---------------

Run these commands from the blogs directory

```
# If this is your first blog
rake blog:directory

# Cd to your directory
cd {firstname}_{lastname}
# Follow the on screen instructions to create your new blog post
rake blog:create
# And begin Editting your new blog
```
A blog can be written in [Markdown](http://daringfireball.net/projects/markdown/), HTML, and [Textile](http://www.textism.com/tools/textile/). You can edit the generated front yaml to make any necessary changes.

Do not remove the date that is generated in the filename

Editing Your Profile
----------------

As part of Near Infinity's new site and blogging system you now have your own profile page. Your profile is located at /blogs/user_name/index.html. This is your personal space to professionally express yourself. Each profile has two sections: an about you section (the front yaml) and a bio section. The bio section is written in standard html. Your profile page can also be written as markdown but you must rename the file index.md. If you add a line to your about you section that contains a colon, you need to surround the entire string in quotes (otherwise it causes compile errors). For example:
```
title: A Great Title

title: "A Greater Title: Part 2"  # This title needs to be surrounded in quotes
```

Committing Changes to Blogs
----------------

Make sure you are located in the blogs directory and committing/pushing changes in the blogs project rather than the root project. You only have push privileges to the blogs directory.

PLEASE NOTE: Any new commits are immediately pushed to the LIVE website. Make sure that your posts are formatted properly BEFORE you push.

Syntax Highlighting
-------------------

    {% highlight <language> %}
    def to_s
      "#{name}"
    end
    {% endhighlight %}

Highlighting with Line Numbers

    {% highlight <language> linenos %}

View list of [languages](http://pygments.org/docs/lexers/) or use the command:

    > pygmentize -L

Embed Videos
------------

    {% video_tag :vimeo => [video_id] %}
    {% video_tag :youtube => [unique_id] %}

Escaping Liquid Syntax
----------------------

Since Liquid is run on your blog (i.e. how the {% highlight %} tag works) you have to escape any Liquid syntax you actually want to display. That is anything that looks like {% %} or {{ }}. To escape

    {% include sharing.html %}
    
you have to say

    {{ "{% include sharing.html " }}%}
    
and to escape

    {{ content }}
    
you have to say

    {{ "{{ content " }}}}


If you have any questions or concerns email bmarcaur@nearinfinity.com or wbrady@nearinfinity.com

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


