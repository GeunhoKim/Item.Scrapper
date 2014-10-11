from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class GmarketViewItemPageSpider(CrawlSpider):
  name = 'GmarketItemCrawler'

  def __init__(self, startUrl='', domain=None):
    self.allowed_domains = ['mitem.gmarket.co.kr']
    self.start_urls = [startUrl]
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()
    item['title'] = hxs.select("//div[@class='prod_tit']/h3/span/text()").extract()[0].encode('utf-8')
    item['imageUrl'] = hxs.select("//img[@id='GoodsImage']/@src").extract()[0].encode('utf-8')
    item['formatPrice'] = hxs.select("//span[@class='pri1']/text()").extract()[0].encode('utf-8')
    item['price'] = item['formatPrice'].replace(",", "")
    return item
