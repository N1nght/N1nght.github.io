---
layout: archive
title: "All News"
permalink: /news/archive/
author_profile: true
---

{% assign news_items = site.news | sort: "date" | reverse %}

<table class="news-table">
<tbody>
{% for item in news_items %}
<tr><td>{{ item.date | date: "%Y-%m-%d" }}</td><td>{{ item.content | remove: "<p>" | remove: "</p>" | strip_newlines | strip }}</td></tr>
{% endfor %}
</tbody>
</table>
