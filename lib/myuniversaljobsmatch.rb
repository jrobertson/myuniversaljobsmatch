#!/usr/bin/env ruby

require 'nokorexi'
require 'dynarex'

# file: myuniversaljobsmatch.rb

class MyUniversalJobsMatch

  def initialize(filepath: '')

    @filepath = filepath
    @url_base = 'https://jobsearch.direct.gov.uk/'
    
    @dx = Dynarex.new 'ujm[title,tags]/item(job_id, title, ' + \
        'description, posting_date, company, location, industries, job_type)'

  end
  
  def dynarex()
    @dx
  end

  def search(title: '', where: '')

    url = @url_base + "jobsearch/powersearch.aspx?qt=2&rad=20&tm=-1&" + \
                                                "where=#{where}&tjt=#{title}"
    doc = Nokorexi.new(url).to_doc

    table = doc.root.at_css('.JSresults')
    a = table.xpath('tr[td]').map do |row|

      # get the date
      date = row.element('td/span/text()')
      link = row.element('td[3]/a')
      jobid = link.attributes[:href][/JobID=(\d+)/,1]
      title = link.text
      url = link.attributes[:href]
      company = row.element('td[4]/span/text()')
      location = row.element('td[5]/span/text()')

      [jobid, date, title, url, company, location]
      
    end

    dx = Dynarex.new('vacancies[title, desc, date, time, tags, xslt]/' + \
             'vacancy(job_id, date, title, url, company, location, created_at)')

    dx.title = "Universal Jobmatch jobs - Search results for '#{title}'"
    dx.desc = "generated from web scrape of jobsearch." + \
                                                "direct.gov.uk; source: " + url
    dx.tags = 'jobs vacancies jobmatch ' + title.split.first
    dx.date = Time.now.strftime("%Y-%b-%s")
    dx.time = Time.now.strftime("%H:%M")

    a.each do |row|
      dx.create Hash[%i(job_id date title url company location created_at).\
                                                                      zip(row)]
    end

    return dx
  end
  
  def query(id)

    url = @url_base + 'GetJob.aspx?JobID=' + id
    buffer = RXFHelper.read(url).first

    doc = Nokorexi.new(buffer.gsub(/<br\s*\/?>/i,"\n")).to_doc
    content = doc.root.at_css '.jobViewContent'
    title = content.element('h2[2]/text()')
    description = content.element('div')

    a = doc.root.at_css('.jobViewSummary').xpath('dl/*')
    
    a2 = []
    while a.length > 0 do

      if a.first.name == 'dt' then
        a2 << [a.shift.text, '']
      elsif
        a2[-1][-1] << a.shift.text + "\n"
      end
    end
    
    a2.concat [['title', title], ['description', description.content]]

    Hash[a2.map{|k,v| [k.downcase.gsub(' ','_').to_sym,v]}]
    
  end
end