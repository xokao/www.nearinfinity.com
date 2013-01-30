---
layout: speaking
title: Reusable and Extensible Fault Tolerance for RESTful Applications
date: 2012-06-25
tags: REST faulttolerance webservices # Space delimited
location: Liverpool, United Kingdom # i.e. Reston, Virginia
talk_url: # Link to additional information about the talk

# Use either the conference or user_group attribute
conference: 
  name: The 11th International Conference on Trust, Security and Privacy in Computing and Communications # Name of the conference
  url: http://www.scim.brad.ac.uk/~hmibrahi/TrustCom2012/ # Website for the conference
---
Despite the simplicity and scalability beneﬁts of REST, rendering RESTful web applications fault-tolerant requires that the programmer write vast amounts of non-trivial, ad-hoc code. Network volatility, HTTP server errors, service outages—all require custom fault handling code, whose effective implementation requires considerable programming expertise and effort. To provide a systematic and principled approach to handling faults in RESTful applications, we present FT-REST—an architectural framework for specifying fault tolerance functionality declaratively and then translating these speciﬁcations into platform-speciﬁc code. FT-REST encapsulates fault tolerance strategies in XML-based speciﬁcations and compiles them to modules that reify the requisite fault tolerance. To validate our approach, we have applied FT-REST to enhance several realistic RESTful applications to withstand the faults described in their FT-REST speciﬁcations. As REST is said to apply verbs (HTTP commands) to nouns (URIs), FT-REST enhances this conceptual model with adverbs that render REST reliable via reusable and extensible fault tolerance.
