#!/usr/bin/env ruby

# file: myuniversaljobsmatch.rb

require 'chronic'
require 'nokorexi'
require 'dynarex'

module StringToDate
  
  refine String do
    
    def to_date()
      Chronic.parse(self, :endian_precedence => :little).to_date
    end
    
  end
  
end

class MyUniversalJobsMatch
  using StringToDate

  def initialize(filepath: '')

    @filepath = filepath

    @url_base = 'https://findajob.dwp.gov.uk/'
    
    @dx = Dynarex.new 'ujm[title,tags]/item(job_id, title, ' + \
        'description, posting_date, company, location, industries, job_type)'

  end
  
  def dynarex()
    @dx
  end
  
  # options:
  #      results_per_page: 10, 25, 50
  #      sort_by: date, highest_salary, lowest_salary
  #      hours: any, full_time, part_time
  #      contract_type: any, permanent, temporary, contract, apprenticeship

  def search(title: '', where: '', results_per_page: nil, sort_by: nil, 
             hours: nil, contract_type: nil)
    
    params = {
      adv: 1,
      q: title,
      w: where
    }
    
    params[:pp] = results_per_page if results_per_page
    params[:cty] = contract_type if contract_type
    params[:cti] = hours if hours
    
    case sort_by.to_sym
    when 'date'
      params[:sb] = :date
      params[:sd] = :down
    when :highest_salary
      params[:sb] = :salary
      params[:sd] = :down
    when :lowest_salary
      params[:sb] = :salary      
      params[:sd] = :up
    end
        
    url = @url_base + 'search/?' + params.map {|x| x.join('=') }.join('&')
    doc = Nokorexi.new(url).to_doc    
    
    rows = doc.root.xpath('//div[@class="search-result"]')
    
    a = rows.map do |row|

      items  = row.xpath('ul/li')
      joburl = row.element('h3/a/@href').to_s
      jobtitle = row.element('h3/a/text()')
      jobid = joburl[/\d+$/]
      jobref = title[/^\d+/].to_s

      date = items[0].text.to_date
      company = items[1].text('strong')
      location = items[1].element('span/text()')
      salary = items[2].text('strong') if items[2]
      desc = row.text('p').strip

      [jobid, jobref, date, jobtitle, joburl, company, location, 
       salary, desc]
      
    end


    dx = Dynarex.new('vacancies[title, desc, date, time, tags, xslt]/' + \
             'vacancy(job_id, job_ref, date, title, url, company, location, salary, desc)')

    dx.title = "Find a job - Search results for '#{title}'"
    dx.desc = "generated from web scrape of Find a job." + \
                                                "findajob.dwp.gov.uk/; source: " + url
    dx.tags = 'jobs vacancies jobmatch ' + title.split.first
    dx.date = Time.now.strftime("%Y-%b-%d")
    dx.time = Time.now.strftime("%H:%M")

    a.each do |row|
      dx.create Hash[(%i(job_id job_ref date title url company) + \
                      %i(location salary desc)).zip(row)]
    end

    return dx
  end
  
  def query(id)

    doc = Nokorexi.new(@url_base + 'details/' + id).to_doc    
    
    title = doc.root.text('head/title')
    
    rows = doc.root.xpath('//table[1]/tbody/tr')
    
    h = rows.map do |tr|
      
      [
        tr.text('th').downcase.rstrip[0..-2].gsub(/ +/,'_').to_sym, 
        tr.text('td').to_s
      ]
      
    end.to_h

    h[:description] = doc.root.element('//div[@itemprop="description"]').xml\
        .gsub(/<br *\/> */,"\n").gsub(/<\/?[^\>]+\/?>/,'').strip    
    
    h[:posting_date] = h[:posting_date].to_date
    h[:closing_date] = h[:closing_date].to_date
    
    {title: title}.merge(h)
    
  end
end
