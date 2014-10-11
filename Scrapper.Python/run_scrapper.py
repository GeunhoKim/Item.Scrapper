#!/usr/bin/python
# coding: utf-8

import cgi, cgitb
import json
cgitb.enable()

from scrapy.xlib.pydispatch import dispatcher
from multiprocessing.queues import Queue

from gmkt_item import GmarketViewItemPageSpider
from iac_item import AuctionViewItemPageSpider
from ebay_item import EbayViewItemPageSpider
from crawler_worker import CrawlerWorker

arguments = cgi.FieldStorage()
startUrl = arguments["startUrl"].value

if "ebay.com" in startUrl:
  spider = EbayViewItemPageSpider(startUrl = startUrl)
if "auction.co.kr" in startUrl:
  spider = AuctionViewItemPageSpider(startUrl = startUrl)
if "gmarket.co.kr" in startUrl:
  spider = GmarketViewItemPageSpider(startUrl = startUrl)

resultQueue = Queue()
crawler = CrawlerWorker(spider, resultQueue)
crawler.start()
items = resultQueue.get()
body = {}
if(len(items) > 0):
  body = json.dumps(items[0].__dict__.get('_values'))

print "Content-Type: application/json"
print "Length:", len(body)
print ""
print body