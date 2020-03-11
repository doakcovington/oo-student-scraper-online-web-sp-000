require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []

    doc.css("div.roster-cards-container").each do |container|
      container.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_profile = {}

    doc.css("div.social-icon-container").children.css("a").each do |social|
      links = social.attribute("href").value
      if links.include?("twitter")
        student_profile[:twitter] = links
      elsif links.include?("linkedin")
        student_profile[:linkedin] = links
      elsif links.include?("github")
        student_profile[:github] = links
      else links.include?("blog")
        student_profile[:blog] = links
      end
    end#end of div.social-icon-container
    student_profile[:bio] = doc.css("div.bio-content.content-holder div.description-holder p").text
    student_profile
  end

end
