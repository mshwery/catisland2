namespace :scrape do

  desc "Gather articles"
  task :rss_feeds => :environment do
    require 'nokogiri'
    require 'open-uri'  

    Source.all.each do |source|
      url = source.rss
      doc = Nokogiri::XML(open(url))
      items = doc.xpath('//item')
      items.each do |item|
        title = item.xpath('title').text
        article = source.articles.find_or_create_by_title(title)
        article.original_html = item.xpath('description').text
        article.original_url = item.xpath('link').text
        article.published_at = item.xpath('pubDate').text
        if article.save
          puts "#{source.name} - #{title}: updated"
          puts article.original_url
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

    Article.all.each do |article|
      doc = Nokogiri::HTML(open(article.original_url))
      item = if article.source.name == "Nola Defender"
        ## NOLA DEFENDER
        doc.css(".contentpage .content").to_s
      elsif article.source.name == "Uptown Messenger"
        ## UPTOWN MESSENGER
        doc.css(".post .entry").to_s
      end
      
      article.original_html = item
      article.save
      puts "#{article.title}: updated"
    end
  end

end