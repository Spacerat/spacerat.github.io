---
layout: post
title: "Swift migration isn't"
date: 2019-07-24 12:23:37 -0700
categories: tech
---

Close to when Apple's new programming language Swift was firt released, I made an iOS app with it. I never published it and I left it untouched for over four years. I decided to try to open it again.

I installed Xcode via the App Store. It's pretty big so it takes a while. I open my project and I'm greeted by this dialog box:

<div class="thumbnailed">
  <a href="/images/swift/swift4.png">
    <img src="/images/swift/swift4.png" alt="Please migration from Swift 3.x to Swift 4 using Xcode 10.1" />
  </a>
  A useful dialog box which I should obviously trust.
</div>

OK, great. I go to Apple's developer website and I download Xcode 10.1. It's a big-old 6GB zip file and it takes a while to download and another while to decompress, but eventually it's open. Eager to begin the migration process, I open my project.

<div class="thumbnailed">
  <a href="/images/swift/swift3.png">
    <img src="/images/swift/swift3.png" alt="Please upgrade from Swift 2.x to Swift 3 using Xcode 8.x" />
  </a>
  Couldn't Apple have kept this dialog box in Xcode 10.2?
</div>

I downloaded Xcode 8.3.3, another 4GB. Unfortunately, it would not decompress.

<div class="thumbnailed">
  <a href="/images/swift/decompress.png">
    <img src="/images/swift/decompress.png" alt="Block-compressed payload operation failed" />
  </a>
  Why do bad things happen to good people?
</div>

https://stackoverflow.com/questions/52658424/xcode-8-cant-be-opened-on-macos-10-14

http://osxdaily.com/2017/04/11/run-macos-virtual-machine-easy-parallels/

https://support.apple.com/en-us/HT208969
