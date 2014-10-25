import re
from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class EbayViewItemPageSpider(CrawlSpider):
  name = 'EbayItemCrawler'

  def __init__(self, startUrl='', domain=None):
    self.allowed_domains = ['http://m.ebay.com']
    self.start_urls = [startUrl]
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()
    item['title'] = hxs.select("//h1[@class='itm-ttl']/text()").extract()[0].encode('utf-8')
    item['imageUrl'] = hxs.select("//img[@class='imgStyle']/@src").extract()[0].encode('utf-8')
    item['formatPrice'] = hxs.select("//div[@id='binPriceRowId']/text()").extract()[0].encode('utf-8')
    item['price'] = float(re.search(r"[0-9\,\.]+\)", item['formatPrice']).group().replace(",", "").replace(")", ""))
    return item
