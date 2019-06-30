---
layout: post
title:  "Debugging HTTPS configuration for Dokku"
date:   2019-06-29 12:23:37 -0700
categories: tech
---

I recently decided to set up my website to use HTTPS. Configuing Github Pages - which [hosts][jekyll] this blog - was easy  . I just had to follow the Github Pages documentation on [troubleshooting custom domains] which directed me to update the `A` records in veryjoe.com's domain configuration, then [check a checkbox][GitHub Pages HTTPS].

Dokku - which [hosts][dokku] my side project web apps - should have been just as easy. There is Dokku plugin called [dokku-letsencrypt] which lets you automatically register and configure [Let's Encrypt] SSL certificates. It promises to get you set up with just 3 commands, but I ran into two issues.

1. It fails if you have misconfigured your app's domain in Dokku.
2. It fails if you're using an incredibly outdated version of the Dokku static site buildpack

In the unlikely event that you are currently dealing with the same issues, hopefully this helps you.

## 1. The Dokku Domain Misconfiguration

The first site I tried to configure was [js.apps.veryjoe.com]. Running `dokku letsencrypt js` produced following error:

> ACME server returned an error: urn:acme:error:malformed :: The request message was malformed :: Error creating new authz :: Name does not end in a public suffix

This suggested something was up with Dokku's Domain name configuration. I investigated with `dokku domains:report`:

    =====> js domains information
           Domains app enabled:           true
           Domains app vhosts:            js.apps
           Domains global enabled:        true
           Domains global vhosts:         apps

    root@apps:~# dokku domains:add-global

Apparently I had misconfigured Dokku, supplying it with just `apps` as the domain name instead of `apps.veryjoe.com`, so the plugin was trying to request a certificate for `js.apps`, and Let's Encrypt wasn't having it.

I tried to reset the global domain configuration, but that didn't actually change the configuration for the `js` app.

    root@apps:~# dokku domains:remove-global apps.veryjoe.com
    -----> Removed apps
    root@apps:~# dokku domains:add-global apps.veryjoe.com
    -----> Added apps.veryjoe.com
    root@apps:~# dokku domains:report
    =====> js domains information
           Domains app enabled:           true
           Domains app vhosts:            js.apps
           Domains global enabled:        true
           Domains global vhosts:         apps.veryjoe.com

I figured that perhaps I just had to clear the app-specific configuration too, and I was right.

    root@apps:~# dokku domains:clear js
    root@apps:~# dokku domains:report
    =====> js domains information
        Domains app enabled:           true
        Domains app vhosts:            js.apps.veryjoe.com
        Domains global enabled:        true
        Domains global vhosts:         apps.veryjoe.com

    root@apps:~# dokku letsencrypt js
    =====> Let's Encrypt js
    ...
    -----> Certificate retrieved successfully.

In conclusion, **Name does not end in a public suffix** is pretty self explainatory. You just need to get your domain names in order!

## 2. The Outdated buildpack

Next I tried [diff.apps.veryjoe.com]. The error (emphesis added):

> **Unable to reach http://diff.apps.veryjoe.com/.well-known/acme-challenge/zWbBBKkpaQD-6O0NXO8FWktijAIKSpDMWI-2K9MlrVw**: HTTPSConnectionPool(host='diff.apps.veryjoe.com', port=443): Max retries exceeded with url: /.well-known/acme-challenge/zWbBBKkpaQD-6O0NXO8FWktijAIKSpDMWI-2K9MlrVw (Caused by SSLError(CertificateError(**"hostname 'diff.apps.veryjoe.com' doesn't match 'js.apps.veryjoe.com'"**,),))

> diff.apps.veryjoe.com was not successfully self-verified. CA is likely to fail as well!

> Generating new certificate private key
> CA marked some of the authorizations as invalid, which likely means **it could not access http://example.com/.well-known/acme-challenge/X**. Did you set correct path in -d example.com:path or --default_root? Is there a warning log entry about unsuccessful self-verification? Are all your domains accessible from the internet? Failing authorizations: https://acme-staging.api.letsencrypt.org/acme/authz/rx8o_z-L66gQgOVHjWWUoLDlIb9vOEPzTBqPvxnYkEM


Let's Encrypt tries to access a file which the dokku-letsencrypt plugin hosts in order to prove that I own the domain, but it fails. 

### Debugging the network error

First I tried looking up **"dokku letsencrypt hostname doesn't match"** and found this [issue] which recommended following some instructions in the plugin's readme. They didn't work but I noticed something suspicious while I was following them:

    root@apps:~# dokku proxy:ports-add diff http:80:5555
    !     No web listeners specified for diff

**No web listeners specified** suggests some kind of network configuration error. I googled around and found that [other][issue2] [resources][multiple domains] conneted nginx to issues with dokku-letsencrypt. So why was `diff` broken in this way but not `js`?

Eventually I ran `dokku network:report`:

    root@apps:~# dokku network:report
    =====> alcoholculator network information
        Network bind all interfaces:   false
        Network listeners:
    =====> diff network information
        Network bind all interfaces:   false
        Network listeners:             
    =====> js network information
        Network listeners:             172.17.0.4:5000
        Network bind all interfaces:   false
    =====> paint network information
        Network listeners:             172.17.0.2:5000
        Network bind all interfaces:   false
    =====> thumbnailer network information
        Network listeners:             172.17.0.3:5000
        Network bind all interfaces:   false

Now I had two hypotheses:

1. `alcoholculator` should also break, and `paint` should succeed
2. The thing that they have in common `diff` and `alcoholculator` is probably the buildpack.

Unfortunately, I hit a snag at this point.

### Avoiding Let's Encrypt rate limits

Let's Encrypt only lets you try to register certificates a few times every three hours. Running `dokku letsencrypt paint`:
    
> There were too many requests of a given type :: Error creating new registration :: too many registrations for this IP: see <https://letsencrypt.org/docs/rate-limits/>

The solution suggested by the link is to use the staging environment while you experiment.

    dokku config:set --no-restart paint DOKKU_LETSENCRYPT_SERVER=staging
    dokku config:set --no-restart alcoholculator DOKKU_LETSENCRYPT_SERVER=staging

### Solving the issue

At this point I was able to prove my hypothsis. Running against their staging environment, `paint` succeeded and `alcoholculator` failed. I took a look at in the repositories for `alcoholculator` and `diff` and in both I found a file called `.env` containing:

    export BUILDPACK_URL=https://github.com/florianheinemann/buildpack-nginx.git

As I began to search for issues related to Dokku's static site buildpack and letsencrypt, I realized that that the buildpack actually lives at <https://github.com/dokku/buildpack-nginx> now. The instructions there tell you to just put a file called `.static` in the root of your repoistory. I did that for `diff` and pushed the changes. Now it had a network listener:

    root@apps:~# dokku network:report diff
    =====> diff network information
        Network bind all interfaces:   false
        Network listeners:             172.17.0.6:5000

And `dokku-letsencrypt diff` ran successfully against the staging environment:

    root@apps:~# dokku letsencrypt diff
    -----> Certificate retrieved successfully.

I decided that it wasn't worth digging into why exactly the old version was breaking things. Sometimes things break, you update them, and then they're fixed 🤷‍♂️.

After fixing `alcoholculator` in the same way, I just had to wait 3 hours for Let's Encrypt's rate limits to reset and then I was able to set everything up.


## Conclusion

Ultimately both of the problems here were of my own making: misconfiguration and outdated dependencies. The [dokku-letsencrypt] plugin is pretty great ([this tutorial] suggests that a Let's Encrypt certificate would be significantly more painful to set up without it!) but no software can completely prevent user error. With decent error messages and warnings, I was able to web-search my way to solutions. I hope you enjoy your secure connection to my [side projects]!

[Let's Encrypt]: https://letsencrypt.org/
[Github Pages HTTPS]: https://help.github.com/en/articles/securing-your-github-pages-site-with-https#enforcing-https-for-your-github-pages-site
[troubleshooting custom domains]: https://help.github.com/en/articles/troubleshooting-custom-domains#dns-configuration-errors
[dokku]: /tech/2014/02/08/Setting-up-shop.html
[apps.veryjoe.com]: http://js.apps.veryjoe.com/
[jekyll]: /tech/2016/09/26/first-post.html
[dokku-letsencrypt]: https://github.com/dokku/dokku-letsencrypt
[js.apps.veryjoe.com]: https://js.apps.veryjoe.com
[diff.apps.veryjoe.com]: https://diff.apps.veryjoe.com
[issue]: https://github.com/dokku/dokku-letsencrypt/issues/152
[issue2]: https://github.com/dokku/dokku-letsencrypt/issues/145
[multiple domains]: https://jonathanmh.com/dokku-with-multiple-domains-and-letsencrypt/
[this tutorial]: https://medium.com/@pimterry/effortlessly-add-https-to-dokku-with-lets-encrypt-900696366890
[side projects]: /projects