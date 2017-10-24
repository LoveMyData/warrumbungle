require 'scraperwiki'
require 'horizon_xml'
require 'mechanize'

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.ssl_version = false

# DNS resoloved 'mycouncil.warrumbungle.nsw.gov.au' to two IP and
# one of them is not working, hard code the working IP address
collector = Horizon_xml.new
collector.agent       = agent
collector.base_url    = 'https://220.233.114.12:6443/Horizon/'
collector.domain      = 'horizondap'
collector.comment_url = 'mailto:info@warrumbungle.nsw.gov.au'
collector.period      = ENV['MORPH_PERIOD']

collector.getRecords.each do |record|
#   p record
  if (ScraperWiki.select("* from data where `council_reference`='#{record['council_reference']}'").empty? rescue true)
    puts "Saving record " + record['council_reference'] + ", " + record['address']
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end
end
