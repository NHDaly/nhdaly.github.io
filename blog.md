---
layout: page
title: Blog
header_title: Blog posts
order: 2
---
<style>
.post-description {
  display: block;
  margin-left: 20px;
  line-height: 100%;
  width: 75%;
}
</style>

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      {% if post.index_description %}
        <p class="post-description"><small><i>{{ post.index_description }}</i></small></p>
      {% endif %}
    </li>
  {% endfor %}
</ul>

<div class="seperator"> </div>

<h3 id="Interact">Interact!</h3>
Since most of my blog posts come originally from Jupyter Notebooks, you can
interact with them and play with them yourself!

They're all available in the [notebooks](/notebooks) directory, but
you can run an interactive notebook through MyBinder, by clicking here!:

<a href="https://mybinder.org/v2/gh/nhdaly/nhdaly.github.io/master?filepath=notebooks"><img src="https://mybinder.org/badge.svg"/></a>

<br>Note that currently MyBinder only supports julia v0.6, so the julia
notebooks may not work. (I'm working on a fix for that, here:
  [https://github.com/jupyter/repo2docker/pull/393](https://github.com/jupyter/repo2docker/pull/393))
