# Scraping the search results from jobsearch.direct.gov.uk using the myuniversaljobsmatch gem

    require 'myuniversaljobsmatch'

    ujm = MyUniversalJobsMatch.new filepath: '/tmp'
    results = ujm.search(title: 'Administrative', where: 'edinburgh')
    puts results.to_xml pretty: true


The above code scrapes the search results from [Universal Jobs Match](https://jobsearch.direct.gov.uk/jobsearch/) and outputs it to a Dynarex document.

## Resources

* myuniversaljobsmatch https://rubygems.org/gems/myuniversaljobsmatch

myuniversaljobsmatch gem jobsearch webscraper
