class CheckrsController < ApplicationController
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'
  require "date"
  
  include Capybara::DSL
  include CheckrsHelper
  
  def index
  end
  
  def create

  p "start********************************"
  d = Date.today
  print(d.year, "年", d.month, "月", d.day, "日")
  

  p params[:data]
  p params[:data][:todofuken]
  p params[:data][:shikugun]
  p params[:data][:chomei]

  p params[:data][:room_type]
  p params[:data][:rent_price]
  p params[:data][:size]
  p params[:data][:comp_year]
  
  #訪問先アドレス
  
  site_config("http://myhome.nifty.com/rent/")
  # 検証用（都道府県ページ以降）
  # site_config("http://myhome.nifty.com/rent/tokyo/city/")  
  driver_setting
    
  # アクセス
  visit('')
  
  # #TOP画面からの遷移
  within(:xpath, '//*[@id="titlePrefSelectSec"]') do
  path = find_link(params[:data][:todofuken])[:"city-search-url"]
  visit("http://myhome.nifty.com#{path}")
  p "1"

  end

   within(:xpath, '//*[@id="citySearchContent"]') do
    p "1"
  click_on params[:data][:shikugun].to_s
     p "2"
  sleep 1
   p "3"
  end


  within(:xpath, '//*[@id="townList"]') do
    p "1"
  click_on  params[:data][:chomei].to_s
   p "2"
  sleep 1
   p "3"
  end

  
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
  
  if params[:data][:comp_year].present?
    if age_year > 20
      qwery_age = 'こだわらない'
      elsif age_year > 15
            qwery_age = '20年以内'
      elsif age_year > 10
            qwery_age = '15年以内'
      elsif age_year > 5
            qwery_age  '10年以内'
      elsif age_year >= 1
            qwery_age = '5年以内'
      elsif
          qwery_age = 'こだわらない'
    end
   select(qwery_age, :from => 'r12')
  end
  
  puts qwery_size
  select(qwery_size, :from => 'r10')
  puts qwery_age 
 
  sleep 3 
  
  #tableのtbodyを取得し、内部のtrを配列で取得
  contents = find('#searchResultList > tbody').all('tr')
  @contents = []
  contents.each_with_index do |content, n|
    if n % 3 == 1
      p content.text
      p content.find('td.ph a')[:href]
      
      test = Test.new
      / / =~ content.find('td.address').text
      test.station = Regexp.last_match.pre_match
      / / =~ content.find('td.address').text
      test.address = Regexp.last_match.post_match
      test.link = content.find('td.ph a')[:href]
      
      
      /分/ =~ content.find('td.minute').text
      test.minute = Regexp.last_match.pre_match

      #test.price = content.find('td.paying').text

      /万円/ =~ content.find('td.paying').text  
      test.fee = Regexp.last_match.post_match
      # /円/ =~ test.fee                        #fee＝管理費なしの物件だとエラーでるので、あとで検討
      # test.fee = Regexp.last_match.pre_match  

      
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
        #test.brand = content.find('td.ph a')[:class]
        test = Test.last
        test.shop = content.find('td.company').text
        test.brand =  content.all('td.company span')[1][:class].split(" ")[1]
        test.save
        @contents << content.text
      end
    end
  
  end
  
   render "checkrs/index"
  
  end
end
