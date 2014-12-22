import re
from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class AmazonViewItemPageSpider(CrawlSpider):
  name = 'AmazonItemCrawler'

  def __init__(self, startUrl='', itemno='', kindOf='', domain=None):
    self.allowed_domains = ['amazon.com']
    self.start_urls = [startUrl]
    self.itemno = itemno
    self.kindOf = kindOf
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()

    title = hxs.select("//h1[@id='title']/text()").extract()
    title = hxs.select("//span[@class='title']/text()").extract() if len(title) < 1 else title
    title = hxs.select("//span[@id='title']/text()").extract() if len(title) < 1 else title
    regex = re.compile(r'[\n\r\t]')
    title = regex.sub("", title[0].encode('utf-8'))
    item['title'] = title

    item['kindOf'] = self.kindOf
    item['itemno'] = self.itemno
        
    imageUrl = hxs.select("//img[@id='detailImg']/@src").extract()
    imageUrl = hxs.select("//img[@id='main-image']/@data-a-hires").extract() if len(imageUrl) < 1 else imageUrl
    item['imageUrl'] = imageUrl[0].encode('utf-8')

    formatPrice = hxs.select("//span[@id='priceblock_ourprice']/text()").extract()
    formatPrice = hxs.select("//span[@class='kindlePrice']/text()").extract() if len(formatPrice) < 1 else formatPrice
    formatPrice = hxs.select("//td[@id='priceblock_dealprice']/span/text()").extract() if len(formatPrice) < 1 else formatPrice
    formatPrice = formatPrice[0].encode('utf-8') if len(formatPrice) >= 1 else "$0.0"
    re.compile(r"\$[0-9\,\.]+")
    formatPrice = re.search(r"\$[0-9\,\.]+", formatPrice).group() 
    item['formatPrice'] = formatPrice

    item['price'] = float(item['formatPrice'].replace("$", "")) * 1000
    return item
