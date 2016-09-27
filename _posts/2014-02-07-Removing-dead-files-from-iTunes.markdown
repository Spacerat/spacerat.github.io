---
layout: post
title:  "Removing dead files from iTunes"
date:   2014-02-07
categories: tech
---

So, I made a blog. Mainly so I have a place to put my things.

I used to have a website which I meticulously handcrafted and put all my stuff on, but it got wiped from the internet and now I'm significantly lazier, Wordpress is a much more attractive option. 

_[edit: Not anymore!]_

Without further ado, I begin the reverse chronological journey through the catalogue of Crap I Made with an underwhelming but still kind of useful entry: an AppleScript which goes through whatever songs you have selected in iTunes and removes any which don't actually point to any files.

[Here's the gist](https://gist.github.com/Spacerat/8772940 "Gist for dead files remover"). My first Applescript! Hacked together from various bits and pieces on The Internet. And because I feel it will make the blog post look nicer, I'll put the code here too:
{% highlight applescript %}
    tell application "iTunes"
      set selectedTracks to selection
      repeat with i from 1 to (length of selectedTracks)
        if class of item i of selectedTracks is not shared track then
          tell item i of selectedTracks to set {loc} to {get location}
          if loc is missing value then
            tell application "iTunes"
              delete item i of selectedTracks
            end tell
          end if
        end if
      end repeat
    end tell
{% endhighlight %}

And [here's a python script](https://gist.github.com/Spacerat/8773118 "Delete duplicate files with different extensions") to accompany it which goes through all your subfolders and deletes the newest of any two files which have the same name except for a different extension.

Can you guess what I've been doing today? That's right, failing to import things in to iTunes properly and then writing code to patch up my mistakes. Could I have combined the two scripts in to a single applescript which actually does the job of hunting for duplicates and deleting the newest? Probably, yes.

Finally, want easy access to that AppleScript, or indeed any script for iTunes? `/Library/iTunes/Scripts`. Create the folder if it doesn't exist already, then it'll show up in a funky little scripts menu in the menubar.
