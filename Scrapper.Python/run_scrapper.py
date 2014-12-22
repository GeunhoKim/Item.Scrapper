#!/usr/bin/python
# coding: utf-8

import cgi, cgitb
import json
import re
cgitb.enable()

from scrapy.xlib.pydispatch import dispatcher
from multiprocessing.queues import Queue
from crawler_worker import CrawlerWorker

arguments = cgi.FieldStorage()
startUrl = arguments["startUrl"].value

if "ebay.com" in startUrl:
  from ebay_item import EbayViewItemPageSpider
  itemno = re.search(r"[0-9]+",startUrl).group()
  ebayUrl = "http://m.ebay.com/itm/" + itemno
  spider = EbayViewItemPageSpider(startUrl=ebayUrl, itemno=itemno, kindOf="ebay")

if "auction.co.kr" in startUrl:
  from iac_item import AuctionViewItemPageSpider
  itemno = re.search(r"[a-z,A-Z][0-9]+",startUrl).group()
  auctionUrl = "http://mobile.auction.co.kr/Item/ViewItem.aspx?itemno=" + itemno  
  spider = AuctionViewItemPageSpider(startUrl = auctionUrl, itemno = itemno, kindOf="auction")

if "gmarket.co.kr" in startUrl:
  from gmkt_item import GmarketViewItemPageSpider
  itemno = re.search(r"goodscode=[0-9]+",startUrl.lower()).group().replace("goodscode=", "")
  gmarketUrl = "http://mitem.gmarket.co.kr/Item?goodsCode=" + itemno
  spider = GmarketViewItemPageSpider(startUrl = gmarketUrl, itemno = itemno, kindOf="gmarket")

if "g9.co.kr" in startUrl:
  from g9_item import G9ViewItemPageSpider
  itemno = re.search(r"[0-9]+",startUrl).group()
  spider = G9ViewItemPageSpider(startUrl = startUrl.encode('utf-8'), itemno = itemno, kindOf="g9")

if "coupang.com" in startUrl:
  from coupang_item import CoupangViewItemPageSpider
  itemno = re.search(r"[0-9]+",startUrl).group()
  spider = CoupangViewItemPageSpider(startUrl = startUrl.encode('utf-8'), itemno = itemno, kindOf="coupang")

if "ticketmonster.co.kr" in startUrl:
  from tmon_item import TmonViewItemPageSpider
  itemno = re.search(r"[0-9]+",startUrl).group()
  spider = TmonViewItemPageSpider(startUrl = startUrl.encode('utf-8'), itemno = itemno, kindOf="tmon")

if "amazon.com" in startUrl:
  from amazon_item import AmazonViewItemPageSpider
  itemno = re.search(r"\/gp\/aw\/d\/[0-9,a-z,A-Z]+",startUrl).group()
  itemno = itemno.replace("/gp/aw/d/", "")
  amazonUrl = "http://www.amazon.com/gp/aw/d/" + itemno
  spider = AmazonViewItemPageSpider(startUrl = amazonUrl, itemno = itemno, kindOf="amazon")  

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