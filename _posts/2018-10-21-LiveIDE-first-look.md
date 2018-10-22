---
layout: post
title: First look at my LiveIDE project
author: Nathan Daly
index_description: >
  Introducing the LiveIDE project I'm building
---

<a name="LiveIDE"></a>
## LiveIDE
I've been building a tool for live-debugging and editing julia code! It's
inspired by Bret Victor's 2012 [Inventing on
Principle](https://vimeo.com/36579366) talk. That talk also inspired similar
tools, like [Hydrogen](https://github.com/nteract/hydrogen), the jupyter
notebook integration for the [Atom](https://github.com/atom/atom) code editor.

I've been working on it since September 2018. I'm currently calling it _LiveIDE_,
but the name is a work-in-progress.

Here's a video I took last month, after the first 4 hours of work on this. (It
was so fast to build! Julia is the best!):<br>
![2018-09-13-LiveIDE-original-demo.gif](/assets/images/LiveIDE/2018-09-13-LiveIDE-original-demo.gif)

I've been using it to test itself nowadays, which has actually been really
helpful! In this screenshot, I'm using `Live.@testfile` to automatically create
live debug inputs for my function _based on the existing unit tests!_:
<p class="hover-for-enlarge">
<a href="/assets/images/LiveIDE/2018-10-21-Screenshot-Test-File.png"><img src="/assets/images/LiveIDE/2018-10-21-Screenshot-Test-File.png" alt="2018-10-21-Screenshot-Test-File" /></a>
</p>

This next example shows more `Live.@testfile` auto testing by using
itself as the unit test file:<br>
![2018-10-21-Screenshot-Self-Test-File](/assets/images/LiveIDE/2018-10-21-Screenshot-Self-Test-File.png)

And of course, it can also act more like a Jupyter notebook with the
`Live.@script` tag, causing the whole file to be interpreted:
<p class="hover-for-enlarge">
<a href="/assets/images/LiveIDE/2018-10-21-Screenshot-Script-Notebook.png"><img src="/assets/images/LiveIDE/2018-10-21-Screenshot-Script-Notebook.png" alt="2018-10-21-Screenshot-Script-Notebook" /></a>
</p>

I'm excited about the future of this project! Expect more updates in the future!

LiveIDE is Copyright © 2018 _nhdalyMadeThis, LLC_, my company for publishing software.<br>
All rights reserved.

<style>
.hover-for-enlarge {
  position: relative;
}

.hover-for-enlarge:hover img {
  opacity: 0.7;
}

.hover-for-enlarge a::after {
  content: "🔍";
  font-size: 30px;
  padding: .5em 1em;
  border-radius: .5em;
  background-color: lightgray;
  transition: .5s ease;
  opacity: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  -ms-transform: translate(-50%, -50%);
  text-align: center;
}
.hover-for-enlarge a:hover::after {
  opacity: 1;
}
</style>
