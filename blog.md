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
      <p class="post-description"><small>
      {% if post.index_description %}
        <i>{{ post.index_description }}</i>
      {% endif %}
      {%- if post.tags -%}
        <br><span class="post-tags">
        {% for tag in post.tags %}
          {%- assign comma = ', ' -%}
          {%- if forloop.last -%}
            {%- assign comma = '' -%}
          {%- endif -%}
          <a href="/tag/{{ tag }}"><nobr>{{ tag }}</nobr></a>{{ comma }}
        {% endfor %}
        </span>
      {%- endif -%}
      </small></p>
    </li>
  {% endfor %}
</ul>

<div class="seperator"> </div>

<h3 id="Interactive posts"><i>Interactive posts!</i></h3>
Since most of my blog posts come originally from Jupyter Notebooks, you can
run all the code, and play with them yourself!

They're all available for download in the [notebooks](/notebooks) directory, and
you can run an interactive notebook through MyBinder, by clicking this button!:

<p align="center"><a href="https://mybinder.org/v2/gh/nhdaly/nhdaly.github.io/master?filepath=notebooks"><img src="https://mybinder.org/badge.svg"/></a></p>

<br>(The above notebooks run in `Julia 0.7`. I updated the MyBinder tool to add
support for `0.7` and for specifying any julia version in this PR!:
[https://github.com/jupyter/repo2docker/pull/393](https://github.com/jupyter/repo2docker/pull/393)))
