---
layout: page
title: CV (Resume)
permalink: /about/
weight: 0
---

<div class="row cv-layout">

<aside class="col-lg-3 order-lg-2 cv-toc-wrapper">
{% include about/toc.html %}
</aside>

<div class="col-lg-9 order-lg-1 cv-content" markdown="1">

# **Curriculum Vitae**

{% include elements/button.html text="📄 Download CV (PDF)" link="/assets/cv/Daniel-Basconcello-Filho-CV.pdf" style="primary" %}

Hi I am **{{ site.author.name }}** :wave:,<br><br>

Senior software engineer with 25+ years building, integrating, and securing systems — from cloud-native platforms on AWS to low-level C++ for embedded electronics and robotics.

I've spent my career taking ideas from zero to one. I helped found Vee Digital, which essentially created Brazil's flexible-benefits market through technology and grew into a global unicorn after merging with Swile France. Along the way I've led infrastructure, security, governance, and observability at companies scaling fast enough to double every few months — implementing KYC flows, designing incident-management processes, and defining the standards that keep platforms reliable under pressure.

My core stack is Java (Spring Boot, Wildfly/J2EE), Python, and PHP, with deep AWS architecture and security expertise across cloud and on-premises environments. I'm equally comfortable in full-stack, full-cycle delivery and in the hardware layer — sensors, embedded devices, IoT, and monitoring systems.

Today I co-found and lead technology, research, and development at IA.PURU, where we turn concepts into market-ready products: intelligent automation, machine-learning and LLM-based solutions, hardware/IoT, and real-time observability.

Outside of work, I'm a hardware hacker, 3D-printing and audio-engineering enthusiast, interactive-art tinkerer, and ocean sailor — the same curiosity that drives how I build.
<section id="languages" class="cv-anchor">

{% assign languages = site.data.hard-skills | where: "category", "language" %}
<div class="row">
{% include about/skills.html title="Languages" source=languages %}
</div>

</section>

<section id="skills" class="cv-anchor">

{% assign hard_skills = site.data.hard-skills | where_exp: "s", "s.category != 'language'" %}
<div class="row">
{% include about/skills.html id="hard-skills" title="Hard Skills" source=hard_skills %}
{% include about/skills.html id="soft-skills" title="Soft Skills" source=site.data.soft-skills %}
</div>

<div class="row">
{% include about/skills.html id="mad-skills" title="Mad Skills" source=site.data.mad-skills %}
{% include about/skills.html id="other-skills" title="Other Skills" source=site.data.other-skills %}
</div>

</section>

<section id="career" class="cv-anchor">
<div class="row">
{% include about/timeline.html %}
</div>
</section>

</div>
</div>
