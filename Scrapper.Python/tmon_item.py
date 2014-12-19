import re
from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class TmonViewItemPageSpider(CrawlSpider):
  name = 'TmonItemCrawler'

  def __init__(self, startUrl='', itemno='', kindOf='', domain=None):
    self.allowed_domains = ['m.ticketmonster.co.kr']
    self.start_urls = [startUrl]
    self.itemno = itemno
    self.kindOf = kindOf
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()
    title = hxs.select("//div[@class='info']/h2/text()").extract()[0].encode('utf-8')
    regex = re.compile(r'[\n\r\t]')
    title = regex.sub("", title)
    item['kindOf'] = self.kindOf
    item['itemno'] = self.itemno
    item['title'] = title
    item['imageUrl'] = hxs.select("//div[@class='thmb']/img/@src").extract()[0].encode('utf-8')
    item['formatPrice'] = hxs.select("//strong[@class='dc']/span/text()").extract()[0].encode('utf-8')
    item['price'] = int(item['formatPrice'].replace(",", ""))
    return item
