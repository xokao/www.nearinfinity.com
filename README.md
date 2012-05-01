NIC Website
===========


QuickStart
----------

    > git clone --recursive git@github.com:nearinfinity/nearinfinity.github.com.git
    > [sudo] easy_install Pygments
    > bundle install
    > bundle exec jekyll --server --auto

This will run a server on <http://localhost:4000> that regenerates any changes


Git Submodule Stuff
-------------------

    > cd blogs
    > git checkout master
    > git pull

Syntax Highlighting
-------------------

    {% highlight <language> [linenos] %}
    def to_s
      "#{name}"
    end
    {% endhighlight %}

View list of languages

    > pygmentize -L
