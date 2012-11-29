desc "Gather articles"
task :rss_feeds => :environment do
  require 'nokogiri'
  require 'open-uri'  

  Source.all.each do |source|
    url = source.rss
    doc = Nokogiri::XML(open(url)) do |config|
      config.noblanks
    end
    items = doc.xpath('//item')
    items.each do |item|
      title = item.xpath('title').text
      article = source.articles.where(title: title).first || source.articles.new(title: title)
      article.original_html = item.xpath('description').text
      article.original_url = item.xpath('link').text
      article.published_at = item.xpath('pubDate').text
      if article.save
        puts "#{source.name} - #{title}: updated"
      else
        puts "Could not save '#{title}'."
      end
      # item.xpath('category').each do |cat|
      #   puts cat.text
      # end
    end
    # price = doc.at_css(".PriceXLBold, .PriceCompare .BodyS").text[/[0-9\.]+/]
    # product.update_attribute(:price, price)
  end
end

desc "Gather full articles"
task :full_articles => :environment do
  require "nokogiri"
  require "open-uri"

  Article.recent.each do |article|
    puts "#{article.id} - #{article.original_url}"
    doc = Nokogiri::HTML(open(article.original_url)) do |config|
      config.noblanks
    end
    item = if article.source.name == "Nola Defender"
      doc.css(".contentpage .content")
    elsif article.source.name == "Uptown Messenger"
      doc.css(".post .entry")
    elsif article.source.name == "The Lens"
      doc.css("#article-body .article-copy")
    elsif article.source.name == "NolaVie"
      doc.css(".post")
    end

    if item
      article.original_html = item.to_s

      item.search('a.excerpt-more').each do |link|
        link.remove if link[:href] == article.original_url # Nola Defender
      end
      item.search('div.sociable').remove # Uptown Messenger

      article.edited_body = item.to_s
      article.save
      puts "updated"
    end
  end
end

task :scrape => [:rss_feeds, :full_articles]
