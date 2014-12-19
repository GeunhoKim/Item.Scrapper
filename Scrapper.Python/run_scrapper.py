#!/usr/bin/python
# coding: utf-8

import cgi, cgitb
import json
import re
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
  itemno = re.search(r"[0-9]+",startUrl).group()
  ebayUrl = "http://m.ebay.com/itm/" + itemno
  spider = EbayViewItemPageSpider(startUrl=ebayUrl, itemno=itemno, kindOf="ebay")

if "auction.co.kr" in startUrl:
  itemno = re.search(r"[a-z,A-Z][0-9]+",startUrl).group()
  auctionUrl = "http://mobile.auction.co.kr/Item/ViewItem.aspx?itemno=" + itemno  
  spider = AuctionViewItemPageSpider(startUrl = auctionUrl, itemno = itemno, kindOf="auction")

if "gmarket.co.kr" in startUrl:
  itemno = re.search(r"goodscode=[0-9]+",startUrl.lower()).group().replace("goodscode=", "")
  gmarketUrl = "http://mitem.gmarket.co.kr/Item?goodsCode=" + itemno
  spider = GmarketViewItemPageSpider(startUrl = gmarketUrl, itemno = itemno, kindOf="gmarket")

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