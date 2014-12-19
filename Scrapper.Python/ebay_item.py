import re
from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector

class EbayViewItemPageSpider(CrawlSpider):
  name = 'EbayItemCrawler'

  def __init__(self, startUrl='', itemno='', kindOf='', domain=None):
    self.allowed_domains = ['http://m.ebay.com']
    self.start_urls = [startUrl]
    self.itemno = itemno
    self.kindOf = kindOf
   
  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    item = ViewItemPage()

    item['kindOf'] = self.kindOf
    item['itemno'] = self.itemno

    title = hxs.select("//h1[@class='itm-ttl']/text()").extract()
    title = hxs.select("//div[@id='itemHeader']/text()").extract() if len(title) < 1 else title
    title = title[0].encode('utf-8') if title else "empty title"
    regex = re.compile(r'[\n\r\t]')
    title = regex.sub("", title)
    item['title'] = title
    
    imageUrl = hxs.select("//img[@class='imgStyle']/@src").extract()
    imageUrl = hxs.select("//img[@class='imgGal']/@src").extract() if len(imageUrl) < 1 else imageUrl
    imageUrl = imageUrl[0].encode('utf-8') if imageUrl else ""
    item['imageUrl'] = imageUrl
    
    formatPrice = hxs.select("//div[@id='binPriceRowId']/text()").extract()
    formatPrice = hxs.select("//span[@id='curBid']/text()").extract() if len(formatPrice) < 1 else formatPrice
    formatPrice = hxs.select("//div[@id='bidPrice']/text()").extract() if len(formatPrice) < 1 else formatPrice
    formatPrice = hxs.select("//div[@id='binPrice']/text()").extract() if len(formatPrice) < 1 else formatPrice
    formatPrice = formatPrice[0].encode('utf-8')
    re.compile(r"[0-9\,\.]+\)")
    formatPrice = re.search(r"[0-9\,\.]+\)", formatPrice).group().replace(")", "") if re.search(r"[0-9\,\.]+\)", formatPrice) else formatPrice
    re.compile(r"\$[0-9\,\.]+")
    formatPrice = re.search(r"\$[0-9\,\.]+", formatPrice).group() if re.search(r"\$[0-9\,\.]+", formatPrice) else "0"
    item['formatPrice'] = formatPrice

    re.compile(r"\$")
    price = float(formatPrice.replace(",", "").replace("$", ""))
    price = price * 1000 if re.match(r"\$", formatPrice) else price
    
    item['price'] = price
    return item