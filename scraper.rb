
"http://nycna.org/index.php?bmlt_settings_id=1305034173&direct_simple&search_parameters=%26block_mode%26meeting_key%3Dlocation_city_subsection%26single_uri%3D.%2F%3Fpage_id%3D24%2526single_meeting_id%3D"
# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'httparty'
require 'active_support/all'
# MEETING_SELECTOR = ".bmlt_simple_meeting_one_meeting_div"
# MEETING_PARSER = {
#   name: ".bmlt_simple_meeting_one_meeting_name_div a",
#   time: ".bmlt_simple_meeting_one_meeting_time_div",
#   day_of_week: ".bmlt_simple_meeting_one_meeting_weekday_div",
#   location_text: ".bmlt_simple_list_location_text",
#   address_line_one: ".bmlt_simple_list_location_street",
#   address_line_two: ".bmlt_simple_list_location_info",
#   city: ".c_comdef_search_results_municipality",
#   state: ".c_comdef_search_results_province",
#   zipcode: ".c_comdef_search_results_zip",
#   country: ".c_comdef_search_results_nation",
#   neighborhood: ".c_comdef_search_results_neighborhood",
#   meeting_format: ".bmlt_simple_meeting_one_meeting_format_div"
# }
MEETING_ATTRIBUTES = ["id_bigint",
 "worldid_mixed",
 "service_body_bigint",
 "weekday_tinyint",
 "start_time",
 "duration_time",
 "formats",
 "lang_enum",
 "longitude",
 "latitude",
 "meeting_name",
 "location_text",
 "location_info",
 "location_street",
 "location_city_subsection",
 "location_neighborhood",
 "location_municipality",
 "location_sub_province",
 "location_province",
 "location_postal_code_1",
 "location_nation",
 "comments",
 "train_lines",
 "bus_lines",
]




def strip_blanks(dict)
  dict.map { |key, value| [key, (value.blank? ? nil : value)] }.to_h
end


def munge_meeting(raw_meeting)
  meeting = strip_blanks(raw_meeting.slice(*MEETING_ATTRIBUTES))
  meeting["id"] = (meeting.delete "id_bigint").to_i
  meeting["name"] = meeting.delete "meeting_name"
  meeting["day_of_week"] = meeting.delete "weekday_tinyint"
  meeting["latitude"] = Float(meeting["latitude"])
  meeting["longitude"] = Float(meeting["longitude"])

  meeting
end


meetings = HTTParty.get("http://nycna.org/index.php?bmlt_settings_id=1305034173&redirect_ajax_json=switcher%3DGetSearchResults%26sort_keys%3Dweekday_tinyint%2Cstart_time&long_val=-73.9565551&lat_val=40.7093358&geo_width=2000")

meetings.map do |raw_meeting|
  meeting = munge_meeting(raw_meeting)
   ScraperWiki.save_sqlite(["id"], meeting)
end

# def parse_meeting(meeting_element)

#   MEETING_PARSER.map do |key, selector|
#     [key, meeting_element.at(selector).text]
#   end.to_h
# end

# agent = Mechanize.new
# url = "http://nycna.org/index.php?bmlt_settings_id=1305034173&direct_simple&search_parameters=%26block_mode%26meeting_key%3Dlocation_city_subsection%26single_uri%3D.%2F%3Fpage_id%3D24%2526single_meeting_id%3D"
# page = agent.get(url)

# meeting_elements = page.search(MEETING_SELECTOR)

# # Read in a page
# page = agent.get("http://foo.com")
#
# # Find somehing on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
#url = "http://nycna.org/index.php?bmlt_settings_id=1305034173&direct_simple&search_parameters=%26block_mode%26meeting_key%3Dlocation_city_subsection%26single_uri%3D.%2F%3Fpage_id%3D24%2526single_meeting_id%3D"
# uri = Addressable::URI.parse(url)

# mechanize = Mechanize.new


