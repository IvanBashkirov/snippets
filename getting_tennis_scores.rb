
require 'rubygems'
require 'nokogiri'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 10
driver.get "http://www.wimbledon.com/en_GB/scores/index.html"
matches = {}

while true
	elems =  driver.find_elements(:class, 'one-col')
	nok_elems = elems.map {|e| Nokogiri::HTML(e.attribute('innerHTML')).at_css('.match-box') }
	nok_elems.each_with_index do |elem, i| 
		next if elem.at_css('.team-one').classes.include?('doubles') 
		match_id = elem.attribute('data-match').value
		next if match_id.nil? || match_id.empty?
		this_match = matches[match_id] || nil
		p match_id
		p elem.at_css('.pts').text
		team_one = elem.at_css('.team-one')
		team_two = elem.at_css('.team-two')
		
		player_one = team_one.at_css('.member-one .name').text
		player_two = team_two.at_css('.member-one .name').text

		p player_one
		p 'vs'
		p player_two

		unless matches.keys.include? match_id
			matches[match_id] =  {completed: false, sets_completed: 0}
			this_match = matches[match_id]
			system('say', "Starting the match between #{player_one} and #{player_two}")
		end

		if  (team_one.at_css('.crticon').classes.include?('winner') || team_two.at_css('.crticon').classes.include?('winner')) && !this_match[:completed]
			this_match[:completed] = true
			if team_one.at_css('.crticon').classes.include?('winner')
				winner = player_one
				loser = player_two
			else
				winner = player_two
				loser = player_one
			end
			system('say', "Fuck yes. #{winner} defeats #{loser}. What an incredible match!")
		end
	end
	sleep 5
p matches
end
