class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'nokogiri'
  require 'open-uri'
   def xkcd
       @xkcdColl = [];
       if(!params[:f] or !params[:l])
         page = Nokogiri::HTML(open("https://xkcd.com/"))
         page.xpath('//body/div[@id = "middleContainer"]/div/img').each do |image|
            logger.debug(image['src'])
            @comic = Comic.new()
            @comic.src = image['src'];
            @comic.title = image['title']
            @comic.alt = image['alt']
            @comic.number = 1000;  #add more refined method to calculate latest
            @xkcdColl.push(@comic);
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
                @xkcdColl.push(@comic);
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
                @xkcdColl.push(@comic);
             end
           end
          @xkcdColl.reverse!
       end
       render partial: "comicColl", object: @xkcdColl
   end
   def buttersafe
       @comicColl = [];
       if(params[:m])
         params[:y] ||= 2012
       else
         params[:y] ||= 2013
       end

       params[:f] ||= 1
       params[:l] ||= 5
       logger.debug "Hey there"
           for i in params[:f]..params[:l]
             logger.debug(i)
             if(params[:m].nil?)
               page = Nokogiri::HTML(open("http://buttersafe.com/#{params[:y]}/page/#{i}")) 
             else
               page = Nokogiri::HTML(open("http://buttersafe.com/#{params[:y]}/#{params[:m]}/page/#{i}")) 
             end
             page.xpath('//div[@class = "comicarchiveframe"]/a/img').each do |image|
                @comic = Comic.new()
                @comic.src = image['src'];
                logger.debug(@comic.src)
                logger.debug(@comic)
                logger.debug(image)
                logger.debug(page)
                @comic.title = image['alt']
                if @comic.src.nil?
                  break
                end
                @comicColl.push(@comic);
             end
           end
       render partial: "butterColl", object: @comicColl
   end
   def nerfnow
       @comicColl = [];
       if(!params[:f] or !params[:l])
         page = Nokogiri::HTML(open("http://nerfnow.com/")) 
         page.xpath('//div[@id = "comic"]/a/img').each do |image|
            logger.debug(image['src'])
            @comic = Comic.new()
            @comic.src = image['src'];
            @comicColl.push(@comic);
         end
       elsif params[:f] < params[:l]
           for i in params[:f]..params[:l]
             page = Nokogiri::HTML(open("http://nerfnow.com/comic/#{i}/")) 
             page.xpath('//div[@id = "comic"]/a/img').each do |image|
                logger.debug(image['src'])
                @comic = Comic.new()
                @comic.src = image['src'];
                @comicColl.push(@comic);
             end
           end
       else
          for i in params[:l]..params[:f]
             page = Nokogiri::HTML(open("http://nerfnow.com/comic/#{i}/")) 
             page.xpath('//div[@id = "comic"]/a/img').each do |image|
                logger.debug(image['src'])
                @comic = Comic.new()
                @comic.src = image['src'];
                @comicColl.push(@comic);
             end
           end
          @comicColl.reverse!
       end
       render partial: "butterColl", object: @comicColl
   end
end
