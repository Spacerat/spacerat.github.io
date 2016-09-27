---
layout: post
title:  "Setting up shop"
date:   2014-02-08
categories: tech
---

I decided to bite the bullet and get myself an actual server on the internets to host my thingamabobs, and here I write about my experience.

I was pointed to [Digital Ocean](https://www.digitalocean.com "Digital Ocean"). $5/month/server for a 512MB an actual VPS on an SSD (actually, $0.007/hour since you can turn your server off and on), not bad!

Like other server providers, they let you create servers with pre-installed software like Wordpress, and Dokku. Wait, Dokku? What's that?

In the words of a friend:

> I set one up at cloud.example.com. Then I git pushed a Go web app to cloud.example.com:goapp and it was up and running at goapp.cloud.example.com.

That sounds fun! So I decided to get my old [WebMines](https://github.com/Spacerat/WebMines "WebMines Github") game running with Dokku, and all it took was one change to the code (I had host the server on the port specified by the _PORT _environment variable), two files

requirements.txt (naming the versions of libraries I've used)

    Cheetah==2.4.4
    CherryPy==3.2.4

and Procfile (pointing to the name of the main file),

    web: python webmines.py

and two commands:

    git remote add dokku dokku@server.ip.address:webmines
    git push dokku master

And done! My terrible, three year old long-polling-based Python-powered incomplete minesweepers game has a [place on the internet](http://mines.apps.veryjoe.com "WebMines"), and when I want to update it, all I have to do is another git push. Be warned, it's occasionally broken and doesn't include a concept of points/success/failure.

<div class="thumbnailed">
  <a href="/images/mines.png">
    <img src="/thumbnails/mines.png" alt="Minesweeper!" />
  </a>
  a fairly uninformative screenshot from the game
</div>

As for hosting static pages like [Plotter](http://js.apps.veryjoe.com/plotter "Canvas Plotter") and [Automa](http://js.apps.veryjoe.com/automa "Automa"), all I had to do was make sure the main page was called index.php, and dokku figured out it was a php application and set up an ngnix server for me. This makes me very happy because it means I get to continue my run of never having have to learn how to actually set up a web server properly.

_P.S: Once I get a bunch of my things up and running, I'll probably do a post about it. Or just make a page for them and post about the page. Or maybe a post about how much I'm annoyed that NodeJS's API has changed so much in three years that I basically have to rewrite half of everything I made back then, but how it's really my fault for not keeping track of which versions of which modules and nodejs runtimes I was using for which app. *grumble*_