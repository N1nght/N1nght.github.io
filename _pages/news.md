---
layout: archive
title: "News"
permalink: /news/
author_profile: true
---

{% assign news_items = site.news | sort: "date" | reverse %}

<table class="news-table">
<tbody>
{% for item in news_items limit: 5 %}
<tr><td>{{ item.date | date: "%Y-%m-%d" }}</td><td>{{ item.content | remove: "<p>" | remove: "</p>" | strip_newlines | strip }}</td></tr>
{% endfor %}
</tbody>
</table>

{% if news_items.size > 5 %}
[View all news →]({{ "/news/archive/" | relative_url }})
{% endif %}
