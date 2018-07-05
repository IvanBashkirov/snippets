
require 'rubygems'
require 'nokogiri'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 15
driver.get "http://www.wimbledon.com/en_GB/scores/index.html"
elems =  driver.find_elements(:class, 'one-col')
nok_elems = elems.map {|e| Nokogiri::HTML(e.attribute('innerHTML')) }


nok_elems.each_with_index do |elem, i| 
	p "match #{i+1}"
	p elem.css('.team-one').css('.set1 .scores > text()').text
	p elem.css('.team-two').css('.set1 .scores > text()').text
end

