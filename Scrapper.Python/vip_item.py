from scrapy.item import Item, Field

class ViewItemPage(Item):
  title = Field(default='')
  imageUrl = Field(default='')
  price = Field(default=0)
  formatPrice = Field(default='')