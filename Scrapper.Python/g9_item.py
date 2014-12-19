from vip_item import ViewItemPage
from scrapy.contrib.spiders import CrawlSpider
from scrapy.selector import HtmlXPathSelector
from selenium import webdriver

class G9ViewItemPageSpider(CrawlSpider):
  name = 'G9ItemCrawler'

  def __init__(self, startUrl='', itemno='', kindOf='', domain=None):
    self.driver = webdriver.Firefox()
    self.allowed_domains = ['m.g9.co.kr']
    self.start_urls = [startUrl]
    self.itemno = itemno
    self.kindOf = kindOf
   
  def parse(self, response):    
    self.driver.get(response.url)
    time.sleep(2.5)    
    
    hxs = HtmlXPathSelector(self.driver.page_source)

    item = ViewItemPage()
    item['kindOf'] = self.kindOf
    item['itemno'] = self.itemno
    item['title'] = hxs.select("//div[@class='tit_bx']/h2/text()").extract()[0].encode('utf-8')
    item['imageUrl'] = hxs.select("//div[@id='list_view']/div/ul/li/img/@src").extract()[0].encode('utf-8')
    item['formatPrice'] = hxs.select("//span[@class='price']/em/text()").extract()[0].encode('utf-8')
    item['price'] = int(item['formatPrice'].replace(",", ""))
    return item