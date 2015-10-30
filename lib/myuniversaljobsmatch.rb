#!/usr/bin/env ruby

require 'nokorexi'
require 'dynarex'

# file: myuniversaljobsmatch.rb

class MyUniversalJobsMatch

  def initialize(filepath: '')

    @filepath = filepath

  end

  def search(title: '', where: '')


    url = "https://jobsearch.direct.gov.uk/jobsearch/" + \
       "powersearch.aspx?qt=2&rad=20&tm=-1&where=#{where}" + \
                                                 "&tjt=#{title}"
    doc = Nokorexi.new(url).to_doc

    table = doc.root.at_css('.JSresults')
    a = table.xpath('tr[td]').map do |row|

      # get the date
      date = row.element('td/span/text()')
      link = row.element('td[3]/a')
      title = link.text
      url = link.attributes[:href]
      company = row.element('td[4]/span/text()')
      location = row.element('td[5]/span/text()')

      [date, title, url, company, location]
      
    end

    dx = Dynarex.new('vacancies[title, desc, date, time, tags, xslt]/vacancy' \
                      + '(date, title, url, company, location, created_at)')
                      
    dx.default_key = 'uid'

    dx.title = "Universal Jobmatch jobs - Search results for '#{title}'"
    dx.desc = "generated from web scrape of jobsearch.direct.gov.uk; source: " + url
    dx.tags = 'jobs vacancies jobmatch ' + title.split.first
    dx.date = Time.now.strftime("%Y-%b-%s")
    dx.time = Time.now.strftime("%H:%M")

    a.each do |row|
      dx.create Hash[%i(date title url company location created_at).zip(row)]
    end

    return dx
  end
end
