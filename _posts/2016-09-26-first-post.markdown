---
layout: post
title:  "Hello Jekyll"
date:   2016-09-26 21:23:37 -0700
categories: tech
---

DigitalOcean's lovely WordPress instance decided it would constantly throw me `Database Errors` which I couldn't be bothered to fix because, in the end, why do I need a database at all?

So I'm trying out Jekyll!

{% highlight python %}
# Also:
def apparently_it_has(nice):
  print("code highlighting %s" % "Built in!")
{% endhighlight %}

So far I'm pretty happy with it, although it took a little effort to set up. My primary stumbling block was themes not working, but it turns out that if you have 

	url: http://mysiteblahblah.com

set in your `_config.yml` file, Jekyll uses that as the absolute URL from which to try to include all static assets (like themes) - not so useful while you're developing locally!

In any case, it's nice to be able to just write in markdown and HTML and instantly preview in my browser, and it's nice to be able to easily and fully manage my own content. I'm hosting this on [github pages](https://pages.github.com/), so all I have to do is `git push origin master` and lo, my blog is updated.
