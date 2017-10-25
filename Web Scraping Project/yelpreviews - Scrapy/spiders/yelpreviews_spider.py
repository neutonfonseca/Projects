from yelpreviews.items import YelpreviewsItem
import scrapy

class yelpreviews_spider(scrapy.Spider):
	name = 'yelpreviews'
	allowed_urls = ['https://www.yelp.com/']
	#Getting all pages from yelp in the start_urls
	start_urls = ['https://www.yelp.com/search?find_loc=New+York,+NY&start=' + str(10*i) + '&cflt=restaurants' for i in range(100)]

	def parse(self,response):
		#Getting the list of url for each restaurant:
		url_list = response.xpath('//ul[@class="ylist ylist-bordered search-results"]/li/div/div/div/div/div/h3/span/a/@href').extract()
		pageurl = ['https://www.yelp.com' + l for l in url_list]

		for url in pageurl:
			yield scrapy.Request(url, callback = self.parse_top, meta={'pageurl':pageurl})
	
	def parse_top(self,response):
		
		name = response.xpath('//div[@class="biz-page-header clearfix"]/div/div/h1/text()').extract()
		overallrating = response.xpath('//div[@class="biz-rating biz-rating-very-large clearfix"]/div/@title').extract()
		price = response.xpath('//div[@class="iconed-list-story"]/dl/dd/text()').extract()
		price = ''.join(price).strip()
		neighborhood = response.xpath('//div[@class="map-box-address u-space-l4"]/span[@class="neighborhood-str-list"]/text()').extract()
		address = response.xpath('//strong[@class="street-address"]/address/text()').extract()
		phonenumber = response.xpath('//span[@class="biz-phone"]/text()').extract()
		pageurl = response.meta['pageurl']

		pages = response.xpath('//div[@class="arrange arrange--stack arrange--baseline arrange--6"]/div[@class="page-of-pages arrange_unit arrange_unit--fill"]/text()').extract()
		pages = ''.join(pages).strip().split()[-1]
		
		#Getting the list of pages inside the restaurant page
		
		restauranturl = []
		for page1 in pageurl:
			for i in range(1, int(pages) + 1):
				restauranturl.append(page1 + '?start=' + str(20*i - 20))

		for restaurant in restauranturl:
			yield scrapy.Request(restaurant, callback = self.parse_page, meta = {'name':name, 
				'overallrating':overallrating, 
				'price':price, 
				'neighborhood':neighborhood, 
				'address':address, 
				'phonenumber':phonenumber})

	def parse_page(self,response):
		name = response.meta['name']
		overallrating = response.meta['overallrating']
		price = response.meta['price']
		neighborhood = response.meta['neighborhood']
		address = response.meta['address']
		phonenumber = response.meta['phonenumber']

		reviews = response.xpath('//div[@class="review review--with-sidebar"]')

		for review in reviews:
			userlocation = review.xpath('./div/div/div/div[@class="media-story"]/ul/li[@class="user-location responsive-hidden-small"]/b/text()').extract()
			userrating = review.xpath('./div/div[@class="review-content"]/div/div/div/@title').extract()
			userratingdate = review.xpath('./div/div[@class="review-content"]/div/span/text()').extract()
			userratingdate = ''.join(userratingdate).strip()
			userlanguage = review.xpath('./div/div[@class="review-content"]/p/@lang').extract()   		
			content = review.xpath('./div/div/p/text()').extract()
			content = "".join(content).strip()

			item = YelpreviewsItem()
			item['name'] = name
			item['overallrating'] = overallrating
			item['price'] = price
			item['neighborhood'] = neighborhood
			item['address'] = address
			item['phonenumber'] = phonenumber
			item['userlocation'] = userlocation
			item['userrating'] = userrating
			item['userratingdate'] = userratingdate
			item['userlanguage'] = userlanguage
			item['content'] = content

			yield item
