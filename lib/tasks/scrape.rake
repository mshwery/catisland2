desc "Gather articles"
task :rss_feeds => :environment do
  require 'nokogiri'
  require 'open-uri'  

  new_items = false
  Source.all.each do |source|
    url = source.rss
    doc = Nokogiri::XML(open(url)) do |config|
      config.noblanks
    end
    items = doc.xpath('//item')
    items.each do |item|
      title = item.xpath('title').text
      unless article = source.articles.find_by_title(title)
        article = source.articles.new(title: title)
        article.original_html = item.xpath('description').text
        article.original_url = item.xpath('link').text
        article.published_at = item.xpath('pubDate').text
        if article.save
          puts "New article: #{source.name} - #{title}"
          new_items = true
        else
          puts "Could not save '#{article.original_url}'."
        end
        # item.xpath('category').each do |cat|
        #   puts cat.text
        # end        
      end
    end
  end
  puts "No new articles" if !new_items
end

desc "Gather full articles"
task :full_articles => :environment do
  require "nokogiri"
  require "open-uri"

  Article.recent.not_scraped.each do |article|
    puts "#{article.id} - #{article.original_url}"
    doc = Nokogiri::HTML(open(article.original_url), nil, 'utf-8') do |config|
      config.noblanks
    end

    #TODO refactor this crap so an admin dev can easily make adjustments 
    item = if article.source.name == "Nola Defender"
      doc.search('a.excerpt-more').each do |link|
        link.remove if link[:href] == article.original_url
      end
      doc.css(".contentpage .content")
    elsif article.source.name == "Uptown Messenger"
      doc.search('div.sociable').remove
      doc.css(".post .entry")
    elsif article.source.name == "The Lens"
      doc.css("#article-body .article-copy")
    elsif article.source.name == "NolaVie" 
      doc.search('h1, div#modal_footer').remove      
      doc.css(".post")
    elsif article.source.name == 'Southern Alpha'
      doc.search('h2, .post-meta span, .mr_social_sharing_wrapper').remove
      doc.css(".post")
    elsif article.source.name == 'Black and Gold Review'
      doc.search('.meta, #notes, .post-title, noscript, script').remove
      doc.css('.post').children
    elsif article.source.name == 'Silicon Bayou News'
      doc.search('.post-title, .tweetthis, .meta, .cats, .tags').remove
      doc.css('.post .entry').children
    end

    if item
      item.xpath('//comment()').remove

      article.original_html = article.edited_body = item.to_s
      article.scraped = true
      article.save
      puts "updated"
    end
  end
end

task :scrape => [:rss_feeds, :full_articles]
