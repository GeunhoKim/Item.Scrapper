import re
from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class CoupangViewItemPageSpider(CrawlSpider):
  name = 'CoupangItemCrawler'

  def __init__(self, startUrl='', itemno='', kindOf='', domain=None):
    self.allowed_domains = ['m.coupang.com']
    self.start_urls = [startUrl]
    self.itemno = itemno
    self.kindOf = kindOf
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()
    title = hxs.select("//dd[@class='title']/b/text()").extract()[0].encode('utf-8')
    regex = re.compile(r'[\n\r\t]')
    title = regex.sub("", title)
    item['kindOf'] = self.kindOf
    item['itemno'] = self.itemno
    item['title'] = title
    item['imageUrl'] = hxs.select("//img[@id='mainImage']/@src").extract()[0].encode('utf-8')
    item['formatPrice'] = hxs.select("//span[@class='salePrc']/text()").extract()[0].encode('utf-8')
    item['price'] = int(item['formatPrice'].replace(",", ""))
    return item
