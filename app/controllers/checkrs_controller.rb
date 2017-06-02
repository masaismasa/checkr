class CheckrsController < ApplicationController
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'
  
  include Capybara::DSL
  include CheckrsHelper
  
  def index
  end
  
  def create

  p "start********************************"
  p params[:data]
  p params[:data][:room_type]
  p params[:data][:rent_price]
  p params[:data][:size]
  
  #訪問先アドレス
  site_config("http://myhome.nifty.com/rent/tokyo/adachiku/oyata")
  driver_setting
    
  # アクセス
  visit('')
  

  
  #検索条件を下記で指定

  select('賃料が安い順', :from => 'sort1')
  select('10件表示', :from => 'pnum')
  
  if params[:data][:rent_price].to_f >= 4 &&  params[:data][:rent_price].to_f < 30
    lower_price = "#{params[:data][:rent_price].to_f.floor}万円以上"
    upper_price = "#{params[:data][:rent_price].to_f.floor+1}万円以下"
    select(lower_price, :from => 'r1')
    select(upper_price, :from => 'r2')
  elsif params[:data][:rent_price].to_f < 4
    upper_price = "4万円以下"
    select(upper_price, :from => 'r2')
  elsif params[:data][:rent_price].to_f >= 30  
    lower_price = "30万円以上"
    select(lower_price, :from => 'r1')
  end
  
  puts lower_price
  puts upper_price
  
  if params[:data][:size].to_f >= 50
    qwery_size = '50平米以上'
    elsif params[:data][:size].to_f >= 40
          qwery_size = '40平米以上'
    elsif params[:data][:size].to_f >= 30
          qwery_size = '30平米以上'
    elsif params[:data][:size].to_f >= 20
          qwery_size = '20平米以上'
    else
          qwery_size = '指定なし'
  end
    
   puts qwery_size
  select(qwery_size, :from => 'r10')


  sleep 3 
  
  #tableのtbodyを取得し、内部のtrを配列で取得
  contents = find('#searchResultList > tbody').all('tr')
  @contents = []
  contents.each_with_index do |content, n|
    if n % 3 == 1
      p content.text
      #p content.find_all("a", class_="detaillink", href="/link")
      #p content.all('a').each{|a| a[:href]}
      #p content.find_link('td.ph') →これだとひとつ上のタグだから、＜A>タグ見つからない。
      #p content.find_link(:xpath,'td/a')
      # p content.find('td.ph').all('a')[:href]
      p content.find('td.ph').all('a')
      # find('div#drawer a')[:href]
      
      #p content.find('td.ph').find.attribute('href').value nilが見つかるらしい
      #p content.find('td.ph').find('a').find.attribute('href')
      
      test = Test.new
      / / =~ content.find('td.address').text
      test.station = Regexp.last_match.pre_match
      / / =~ content.find('td.address').text
      test.address = Regexp.last_match.post_match
      #test.link = content.find('td.ph').find_link
      
      
      /分/ =~ content.find('td.minute').text
      test.minute = Regexp.last_match.pre_match

      #test.price = content.find('td.paying').text

      /万円/ =~ content.find('td.paying').text
      test.fee = Regexp.last_match.post_match
      /円/ =~ test.fee
      test.fee = Regexp.last_match.pre_match  

      /万円/ =~ content.find('td.paying').text
      test.price = Regexp.last_match.pre_match

      #test.reisiki = content.find('').text

      / / =~ content.find('td.floor').text
      test.madori = Regexp.last_match.pre_match


      / / =~ content.find('td.floor').text
      test.size = Regexp.last_match.post_match
      /m²/ =~ test.size
      test.size = Regexp.last_match.pre_match

      / / =~ content.find('td.buildDetail').text
      test.floor =  Regexp.last_match.pre_match

      / / =~ content.find('td.buildDetail').text
      test.age =  Regexp.last_match.post_match
      
      test.save
      
      @contents << content.text
    elsif n % 3 == 0  && n != 0
      p content.text
       if content.find('td.company').present?
         test = Test.last
         test.shop = content.find('td.company').text
         test.save
        @contents << content.text
       end
    end
  
  end
  
  render "checkrs/index"
  
  end
end
