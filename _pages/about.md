---
permalink: /
title: "About"
author_profile: true
redirect_from:
  - /about/
  - /about.html
---

I am currently a PhD student in the School of Transportation at Southeast University, supervised by Prof. Qixiu Cheng and Prof. Zhiyuan Liu.
My research interests include operations research and machine learning applied to transportation.

News
===

{% assign latest_news = site.news | sort: "date" | reverse %}
{% if latest_news.size > 0 %}
<table class="news-table">
<tbody>
{% for item in latest_news limit: 5 %}
<tr><td>{{ item.date | date: "%Y-%m-%d" }}</td><td>{{ item.content | remove: "<p>" | remove: "</p>" | strip_newlines | strip }}</td></tr>
{% endfor %}
</tbody>
</table>

[View all news →]({{ "/news/archive/" | relative_url }})
{% else %}
_No news has been posted yet._
{% endif %}

Selected Publication
===

{% assign selected_publications = site.data.publications | where: "selected", true | sort: "year" | reverse %}
{% if selected_publications.size > 0 %}
{% for publication in selected_publications limit: 2 %}
- {{ publication.reference }}{% if publication.doi %} <a href="https://doi.org/{{ publication.doi }}">Read Online</a>{% endif %}
{% endfor %}
{% else %}
_No selected publications have been configured yet._
{% endif %}
