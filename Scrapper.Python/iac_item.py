from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class AuctionViewItemPageSpider(CrawlSpider):
  name = 'AuctionItemCrawler'

  def __init__(self, startUrl='', domain=None):
    self.allowed_domains = ['mobile.auction.co.kr']
    self.start_urls = [startUrl]
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()
    item['title'] = hxs.select("//span[@class='product-info_name']/text()").extract()[0].encode('utf-8')
    item['imageUrl'] = hxs.select("//li[@class='content-slider_item active']/a/img/@src").extract()[0].encode('utf-8')
    item['formatPrice'] = hxs.select("//strong[@class='product-info_offer_price']/text()").extract()[0].encode('utf-8')
    item['price'] = hxs.select("//input[@id='dsPrice']/@value").extract()[0].encode('utf-8')
    return item
