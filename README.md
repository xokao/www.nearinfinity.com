NIC Website
===========


Setup Repository
----------------

```
# Clone repo and blogs submodule
git clone --recursive git@github.com:nearinfinity/nearinfinity.github.com.git
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

    bundle exec jekyll --server --auto

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
