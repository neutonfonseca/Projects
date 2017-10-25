from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd
import time
import csv

urlforeachrest = pd.read_csv('seamlessurls.csv')
driver = webdriver.Chrome()

csv_file = open('seamlessreviews_fin2.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['name', 'adress', 'city', 'phonenumber', 'price', 'overallrating', 'deliverytime', 'content', 'username', 'date', 'userratingeven', 'userratingodd' 'overallfood', 'overalldelivery', 'overallorder'])

for url in urlforeachrest.url[2000:4000]:
	driver.get(url)

	index = 1
	while True:
		time.sleep(2)
		try:
			print("Scraping Page number " + str(index))
			index = index + 1

			reviews = driver.find_elements_by_xpath('//*[@id="ghs-restaurantPage-reviewHighlights"]/ghs-in-view/div[2]/div/ghs-restaurant-review-item')

			for review in reviews:
				review_dict = {}

				name = review.find_element_by_xpath('//*[@id="ghs-restaurant-summary"]/div/div[2]/div[2]/h1').text
				address = review.find_element_by_xpath('//*[@id="ghs-restaurant-summary"]/div/div[2]/div[2]/div[1]/span/a').text
				city = review.find_element_by_xpath('//*[@id="ghs-restaurant-about"]/div/div[2]/div/a[2]').text
				phonenumber = review.find_element_by_xpath('//*[@id="ghs-restaurant-summary"]/div/div[2]/div[2]/div[1]/ghs-restaurant-phone/a').text
				price = review.find_element_by_xpath('//*[@id="ghs-restaurant-about"]/div/div[1]/ghs-price-rating/div/div[1]').text
				overallrating = review.find_element_by_xpath('//*[@id="ghs-restaurant-summary"]/div/div[2]/div[2]/div[2]/div/ghs-star-rating/div/div/div[1]/ghs-stars/div/div[2]').get_attribute('style')
				deliverytime = review.find_element_by_xpath('//*[@id="navSection-menu"]/ghs-cart-header/header/div/div/div/div[1]/div[1]').text
				content = review.find_element_by_xpath('.//div[@class="s-container-fluid"]/p').text
				username = review.find_element_by_xpath('.//div[@class="s-col-sm-12 s-col-xs-10 s-row review-reviewer"]/h5').text
				date = review.find_element_by_xpath('.//div[@class="caption u-text-secondary"]/span/span[@class="meta-label"]').text
				userratingeven = review.find_element_by_xpath('//*[@class="review-container review-container--even"]/div/div[3]/div[1]/div[1]/div[1]/ghs-star-rating/div/div/div/ghs-stars/div/div[2]').get_attribute('style')
				userratingodd = review.find_element_by_xpath('//*[@class="review-container review-container--odd"]/div/div[3]/div[1]/div[1]/div[1]/ghs-star-rating/div/div/div/ghs-stars/div/div[2]').get_attribute('style')
				overallfood = review.find_element_by_xpath('//*[@id="ghs-restaurantPage-reviewHighlights"]/ghs-in-view/div[1]/div/div[1]/div/ghs-rating-facets/div/div/div[2]/ul/li[1]/span[1]').text
				overalldelivery = review.find_element_by_xpath('//*[@id="ghs-restaurantPage-reviewHighlights"]/ghs-in-view/div[1]/div/div[1]/div/ghs-rating-facets/div/div/div[2]/ul/li[2]/span[1]').text
				overallorder = review.find_element_by_xpath('//*[@id="ghs-restaurantPage-reviewHighlights"]/ghs-in-view/div[1]/div/div[1]/div/ghs-rating-facets/div/div/div[2]/ul/li[3]/span[1]').text

				review_dict['name'] = name
				review_dict['address'] = address
				review_dict['city'] = city
				review_dict['phonenumber'] = phonenumber
				review_dict['price'] = price
				review_dict['overallrating'] = overallrating
				review_dict['deliverytime'] = deliverytime
				review_dict['content'] = content
				review_dict['username'] = username
				review_dict['date'] = date
				review_dict['userratingeven'] = userratingeven
				review_dict['userratingodd'] = userratingodd
				review_dict['overallfood'] = overallfood
				review_dict['overalldelivery'] = overalldelivery
				review_dict['overallorder'] = overallorder
				writer.writerow(review_dict.values())

			button = driver.find_element_by_xpath('//*[@id="nextReviewPage"]')
			driver.execute_script("arguments[0].click();", button)

		except Exception as e:
			print(e)
			break

csv_file.close()
driver.close()