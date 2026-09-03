---
layout: archive
title: "Working Papers"
permalink: /working-papers/
author_profile: true
---

{% assign working = site.data.publications | where: "category", "working_papers" | sort: "year" | reverse %}

<ol>
{% for publication in working %}
<li>{{ publication.reference }}</li>

{% endfor %}
</ol>
