class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'nokogiri'
  require 'open-uri'
   def dansfunction
       @comicColl = [];
       if(!params[:f] or !params[:l])
         page = Nokogiri::HTML(open("https://xkcd.com/"))
         page.xpath('//body/div[@id = "middleContainer"]/div/img').each do |image|
            logger.debug(image['src'])
            @comic = Comic.new()
            @comic.src = image['src'];
            @comic.title = image['title']
            @comic.alt = image['alt']
            @comic.number = 1000;  #add more refined method to calculate latest
            @comicColl.push(@comic);
         end
       elsif params[:f] < params[:l]
           for i in params[:f]..params[:l]
             page = Nokogiri::HTML(open("https://xkcd.com/#{i}/"))
             page.xpath('//body/div[@id = "middleContainer"]/div/img').each do |image|
                logger.debug(image['src'])
                @comic = Comic.new()
                @comic.src = image['src'];
                @comic.title = image['title']
                @comic.alt = image['alt']
                @comic.number = i;
                @comicColl.push(@comic);
             end
           end
       else
          for i in params[:l]..params[:f]
             page = Nokogiri::HTML(open("https://xkcd.com/#{i}/"))
             page.xpath('//body/div[@id = "middleContainer"]/div/img').each do |image|
                logger.debug(image['src'])
                @comic = Comic.new()
                @comic.src = image['src'];
                @comic.title = image['title']
                @comic.alt = image['alt']
                @comic.number = i;
                @comicColl.push(@comic);
             end
           end
          @comicColl.reverse!
       end
       render partial: "comicColl", object: @comicColl
   end
end
