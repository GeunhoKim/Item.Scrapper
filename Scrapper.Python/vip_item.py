from scrapy.item import Item, Field

class ViewItemPage(Item):
  kindOf = Field(default='')
  itemno = Field(default='')
  title = Field(default='')
  imageUrl = Field(default='')
  price = Field(default=0)
  formatPrice = Field(default='')