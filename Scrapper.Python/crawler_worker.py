from scrapy import project, signals
from scrapy.conf import settings
from scrapy.crawler import CrawlerProcess
from scrapy.xlib.pydispatch import dispatcher
from multiprocessing.queues import Queue
import multiprocessing

class CrawlerWorker(multiprocessing.Process):
  
  def __init__(self, spider, result_queue):
    multiprocessing.Process.__init__(self)
    self.result_queue = result_queue
    
    setting = settings
    setting.overrides['USER_AGENT'] = 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53'
    self.crawler = CrawlerProcess(setting)
    if not hasattr(project, 'crawler'):
      self.crawler.install()
      self.crawler.configure()
      
      self.items = []
      self.spider = spider
      dispatcher.connect(self._item_passed, signals.item_passed)
  
  def _item_passed(self, item):
    self.items.append(item)
  
  def run(self):
    self.crawler.crawl(self.spider)
    self.crawler.start()
    self.crawler.stop()
    self.result_queue.put(self.items)