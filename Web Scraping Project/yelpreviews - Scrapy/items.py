# -*- coding: utf-8 -*-

import scrapy


class YelpreviewsItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    name = scrapy.Field()
    neighborhood = scrapy.Field()
    overallrating = scrapy.Field()
    price = scrapy.Field()
    typeoffood = scrapy.Field()
    address = scrapy.Field()
    phonenumber = scrapy.Field()
    userlocation = scrapy.Field()
    userrating = scrapy.Field()
    userlanguage = scrapy.Field()
    content = scrapy.Field()
    userratingdate = scrapy.Field()
    delivery = scrapy.Field()


