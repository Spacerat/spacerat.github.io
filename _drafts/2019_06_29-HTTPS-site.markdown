---
layout: post
title:  "Configuring HTTPS for GitHub Pages and Dokku"
date:   2019-06-29 12:23:37 -0700
categories: tech
---

Your connection to this website is now secure! Your favourite blog now lives at [https://veryjoe.com](https://veryjoe.com) and no where else. If you ever connected to a fake Starbucks Wifi hotspot run by a hacker and tried to visit my blog, someone could have sent you to a truckload of driveby virus downloads instead. Now that risk is gone!

Really, I should have given more thought to HTTPS when I [set up][jekyll] this iteration of my website up in 2016, but I didn't. I just dumped my content into a [Github Pages repository] repository with all defaults intact and configured veryjoe.com to point to it, and I was rewarded with a plain old HTTP website. Between then and now I've mostly neglected this site so I didn't think much more of it.

But I'm here now, and the lack of security is embarrassing. In addition to the security risks, Google has [downranked HTTPS websites] since at least since 2014, and Google Chrome [started labeling][Chrome Not Secure] HTTP websites as insecure in 2018. The message is clear: to be a good citizen contributor to the web, one must use HTTPS.

Coming back to this website recently, I set out to make things right. My website consits of two parts: veryjoe.com, the blog you're reading now; and [apps.veryjoe.com] which is the same DigitalOcean Dokku server [I set up][dokku] in 2014 to host my side projects.

## Configuring HTTPS for Github Pages (veryjoe.com)

Shortly after Chrome started calling out HTTP websites, GitHub Pages [added][GitHub Pages HTTPS] HTTPS support for websites with custom domains. Their [documentation][GitHub Pages HTTPS] suggested that I should just be able to check a box (a feature apparenly [added][GitHub Pages HTTPS added] in 2018), but the box was not enabled for me. On their [troubleshooting custom domains] page I found this: 

> If you're using an `A` record that points to 192.30.252.153 or 192.30.252.154, you'll need to update your DNS settings for your site to be available over HTTPS or served with a Content Delivery Network. For more information, see "HTTPS errors."

This was my problem exactly. After I updated my `A` record, GitHub's checkbox's error message now informed me that I had to wait a day. I waited, then clicked the checkbox, then the change was made.

## Configuring HTTPS for Dokku (apps.veryjoe.com)


I discovered that Dokku has a [plugin][dokku-letsencrypt] which lets you automatically configure a [Let's Encrypt] certificate. I was running an ancient version of Dokku so I started by setting up a completely new Dokku instance with the latest version. Then I followed the instructions to install it but I hit a snag at `dokku letsencrypt js`:

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
    -----> Creating new /home/dokku/js/VHOST...
    -----> Configuring js.apps.veryjoe.com...(using built-in template)
    -----> Creating http nginx.conf
    -----> Running nginx-pre-reload
        Reloading nginx
    -----> Cleared domains in js

    root@apps:~# dokku domains:report
    =====> js domains information
        Domains app enabled:           true
        Domains app vhosts:            js.apps.veryjoe.com
        Domains global enabled:        true
        Domains global vhosts:         apps.veryjoe.com

    root@apps:~# dokku letsencrypt js
    =====> Let's Encrypt js
    -----> Updating letsencrypt docker image...
    latest: Pulling from dokkupaas/letsencrypt-simp_le
    Digest: sha256:95681f7cd659f23f451738121df9efe42ffc919e93a969781c40e936258fea72
    Status: Image is up to date for dokkupaas/letsencrypt-simp_le:latest
        done updating
    -----> Enabling ACME proxy for js...
    -----> Getting letsencrypt certificate for js...
            - Domain 'js.apps.veryjoe.com'
    darkhttpd/1.12, copyright (c) 2003-2016 Emil Mikulic.
    listening on: http://0.0.0.0:80/
    2019-06-30 01:31:24,119:INFO:__main__:1211: Generating new account key
    2019-06-30 01:31:25,926:INFO:__main__:1305: js.apps.veryjoe.com was successfully self-verified
    2019-06-30 01:31:26,039:INFO:__main__:1313: Generating new certificate private key
    2019-06-30 01:31:29,941:INFO:__main__:391: Saving account_key.json
    2019-06-30 01:31:29,942:INFO:__main__:391: Saving fullchain.pem
    2019-06-30 01:31:29,942:INFO:__main__:391: Saving chain.pem
    2019-06-30 01:31:29,943:INFO:__main__:391: Saving cert.pem
    2019-06-30 01:31:29,943:INFO:__main__:391: Saving key.pem
    -----> Certificate retrieved successfully.
    -----> Installing let's encrypt certificates
    -----> Configuring js.apps.veryjoe.com...(using built-in template)
    -----> Creating https nginx.conf
    -----> Running nginx-pre-reload
        Reloading nginx
    -----> Configuring js.apps.veryjoe.com...(using built-in template)
    -----> Creating https nginx.conf
    -----> Running nginx-pre-reload
        Reloading nginx
    -----> Disabling ACME proxy for js...
        done

Then I tried another application, but it failed with the following errors

> **Unable to reach http://diff.apps.veryjoe.com/.well-known/acme-challenge/zWbBBKkpaQD-6O0NXO8FWktijAIKSpDMWI-2K9MlrVw**: HTTPSConnectionPool(host='diff.apps.veryjoe.com', port=443): Max retries exceeded with url: /.well-known/acme-challenge/zWbBBKkpaQD-6O0NXO8FWktijAIKSpDMWI-2K9MlrVw (Caused by SSLError(CertificateError(**"hostname 'diff.apps.veryjoe.com' doesn't match 'js.apps.veryjoe.com'"**,),))

> diff.apps.veryjoe.com was not successfully self-verified. CA is likely to fail as well!

> Generating new certificate private key
> CA marked some of the authorizations as invalid, which likely means **it could not access http://example.com/.well-known/acme-challenge/X**. Did you set correct path in -d example.com:path or --default_root? Is there a warning log entry about unsuccessful self-verification? Are all your domains accessible from the internet? Failing authorizations: https://acme-staging.api.letsencrypt.org/acme/authz/rx8o_z-L66gQgOVHjWWUoLDlIb9vOEPzTBqPvxnYkEM



[Let's Encrypt]: https://letsencrypt.org/
[GitHub Pages HTTPS added]: https://github.blog/2018-05-01-github-pages-custom-domains-https/
[Github Pages HTTPS]: https://help.github.com/en/articles/securing-your-github-pages-site-with-https
[troubleshooting custom domains]: https://help.github.com/en/articles/troubleshooting-custom-domains#dns-configuration-errors
[Github Pages repository]: https://github.com/Spacerat/Spacerat.github.io
[Chrome Not Secure]: https://security.googleblog.com/2018/02/a-secure-web-is-here-to-stay.html
[downranked HTTPS websites]: https://webmasters.googleblog.com/2014/08/https-as-ranking-signal.html
[dokku]: /tech/2014/02/08/Setting-up-shop.html
[apps.veryjoe.com]: http://js.apps.veryjoe.com/
[jekyll]: /tech/2016/09/26/first-post.html
[dokku-letsencrypt]: https://github.com/dokku/dokku-letsencrypt