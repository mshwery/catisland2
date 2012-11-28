desc "Gather articles"
task :gather_articles => :environment do
  require 'nokogiri'
  require 'open-uri'  
  Source.all.each do |source|
    url = source.rss
    doc = Nokogiri::XML(open(url))
    items = doc.xpath('//item')
    items.each do |item|
      title = item.xpath('title').text
      article = source.articles.find_or_create_by_title(title)
      article.raw = item.xpath('description').text
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