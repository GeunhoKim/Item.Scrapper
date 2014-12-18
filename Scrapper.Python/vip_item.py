from scrapy.item import Item, Field

class ViewItemPage(Item):
  itemno = Field(default='')
  title = Field(default='')
  imageUrl = Field(default='')
  price = Field(default=0)
  formatPrice = Field(default='')