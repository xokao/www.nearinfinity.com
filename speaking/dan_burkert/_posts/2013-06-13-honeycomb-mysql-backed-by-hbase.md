---
layout: speaking
title: "Honeycomb: MySQL Backed by HBase"
date: 2013-06-13
location: San Francisco, California
conference:
  name: HBaseCon
  url: "http://www.hbasecon.com/"
tags: hbase
---
Honeycomb is an exciting new open-source storage engine plugin for MySQL that
enables MySQL to store and query tables directly in HBase.  Honeycomb brings
HBase's inherent scalability, availability, and performance to MySQL's
relational data model.  By storing tables directly in HBase and allowing direct
access to MySQL for queries and modification, Honeycomb enables developers to
work with the familiar and powerful relational model, and allows access to the
data by existing Hadoop-based tools.  This talk will explore the architecture
of Honeycomb, use cases, and dive into how Honeycomb implements a relational
data model on top of HBase which allows for efficient querying.
