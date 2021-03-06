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
  room = Room.all.destroy_all
  d = Date.today
  print(d.year, "年", d.month, "月", d.day, "日")
  
  qwery = Qwery.new
  qwery.todofuken =  params[:data][:todofuken]
  qwery.shikugun = params[:data][:shikugun]
  qwery.chomei = params[:data][:chomei]
  qwery.type =  params[:data][:room_type]
  qwery.price = params[:data][:rent_price]
  qwery.size = params[:data][:size]
  qwery.comp_year = params[:data][:comp_year]

  qwery.save
  
  @qwery = qwery
  
  #訪問先アドレス
  
  site_config("http://myhome.nifty.com/rent/")
  # 検証用（都道府県ページ以降）
  # site_config("http://myhome.nifty.com/rent/tokyo/city/")  
  driver_setting
    
  # アクセス
  visit('')
  
  # #TOP画面からの遷移
  within(:xpath, '//*[@id="titlePrefSelectSec"]') do
  path = find_link(params[:data][:todofuken].chop)[:"city-search-url"]
  visit("http://myhome.nifty.com#{path}")
  p "1"

  end
  sleep 1
   within(:xpath, '//*[@id="citySearchContent"]/div[4]') do
    p "1"
  find_link(params[:data][:shikugun].to_s).trigger('click')
     p "2"
  sleep 1
   p "3"
  end


  within(:xpath, '//*[@id="townList"]') do
    p "1"
  find_link(params[:data][:chomei].to_s).trigger('click')  
   p "2"
  sleep 1
   p "3"
  end

  
  #検索条件を下記で指定
  
  
  select('賃料が安い順', :from => 'sort1')
  select('60件表示', :from => 'pnum')
  
  if params[:data][:rent_price].to_f >= 4 &&  params[:data][:rent_price].to_f < 30
    p params[:data][:rent_price].to_f
    p params[:data][:rent_price].to_f*2
    lower_price = (BigDecimal((params[:data][:rent_price].to_f*2).to_s).floor(0).to_f)/2
    p lower_price
    if lower_price.to_s.include?(".0") 
      lower_price = lower_price.to_i
    end
    lower_price = "#{lower_price}万円以上"
    p lower_price
    
    upper_price = (BigDecimal((params[:data][:rent_price].to_f*2+0.5).to_s).round(0).to_f)/2
    p upper_price
    if upper_price.to_s.include?(".0") 
      upper_price = upper_price.to_i
    end
    upper_price = "#{upper_price}万円以下"
    p upper_price
    
    # upper_price = "#{(BigDecimal((params[:data][:rent_price].to_f*2).to_s).round(0).to_f)/2}万円以下"
    # lower_price = "#{params[:data][:rent_price].to_f.floor}万円以上"
    # upper_price = "#{params[:data][:rent_price].to_f.floor+1}万円以下"
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
    age_year = d.year - params[:data][:comp_year].to_f
    p age_year
    if age_year > 20
      qwery_age = 'こだわらない'
      elsif age_year > 15
            qwery_age = '20年以内'
      elsif age_year > 10
            qwery_age = '15年以内'
      elsif age_year > 5
            qwery_age = '10年以内'
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
 
  sleep 5 
  
  #tableのtbodyを取得し、内部のtrを配列で取得
  contents = find('#searchResultList > tbody').all('tr')
  
  contents.each_with_index do |content, n|
    if n % 3 == 1
     
      room = Room.new
      / / =~ content.find('td.address').text
      room.station = Regexp.last_match.pre_match
      / / =~ content.find('td.address').text
      room.address = Regexp.last_match.post_match
      room.link = content.find('td.ph a')[:href]
      
      if content.find('td.minute').text.split("分",2) [0].present?
      room.minute = content.find('td.minute').text.split("分",2) [0] 
      else
      room.minute = "0"
      end
    
      # /分/ =~ content.find('td.minute').text
      # room.minute = Regexp.last_match.pre_match.to_i
      
      #room.price = content.find('td.paying').text

      room.fee = content.find('td.paying').text.split(" ",2) [1] 
      # /万円/ =~ content.find('td.paying').text  
      # room.fee = Regexp.last_match.post_match
      # /円/ =~ room.fee                        #fee＝管理費なしの物件だとエラーでるので、あとで検討
      # room.fee = Regexp.last_match.pre_match  

      
      /万円/ =~ content.find('td.paying').text
      room.price = Regexp.last_match.pre_match  #.to_f

      
      #room.reisiki = content.find('').text

      / / =~ content.find('td.floor').text
      room.madori = Regexp.last_match.pre_match


      / / =~ content.find('td.floor').text
      henkan = Regexp.last_match.post_match
      /m²/ =~ henkan
      room.size = Regexp.last_match.pre_match

      / / =~ content.find('td.buildDetail').text
      room.floor =  Regexp.last_match.pre_match

      p content.find('td.buildDetail').text
      p content.find('td.buildDetail').text.split(" ",2) [1] 
      room.age = content.find('td.buildDetail').text.split(" ",2) [1] 
       
      
      room.save
    

    elsif n % 3 == 0  && n != 0
      p content.text
      if content.find('td.company').present?
        room = Room.last
        
        room.shop = content.find('td.company').text.delete("配信元: ")
      room.brand =  content.all('td.company span')[1][:class].split(" ")[1].gsub(/homesf|forrenf|mynavif|chintaf|jseef|athomef|adparkf|pitatf|apamanf|centurf|zigexnf|/, "jseef" => "いい部屋ネット", "athomef" => "at home", "adparkf" => "アドパーク", "pitatf" => "ピタットハウス", "homesf" => "HOMES", "forrenf" => "SUUMO", "mynavif" => "マイナビ賃貸", "chintaf" => "CHINTAI", "apamanf" => "アパマンショップ", "centurf" => "センチュリー21", "zigexnf" => "smocca")
        room.save

      end
    end
  
  end
  
  # p qwery
  
   # redirect_to :back
   # redirect_to root_path
   

  @rooms = []
  @rooms = Room.all
  
  @matches = []
  @matches = Room.where(price: params[:data][:rent_price].to_d, size: params[:data][:size].to_d).all
  # @matches = Room.all
  
  p @matches

  # qwery.size = params[:data][:size]
  # qwery.comp_year = params[:data][:comp_year]

   
   render "checkrs/index"
  
  rescue => e
  @error = e
  p @error.class
  p @error.message
  render "checkrs/index"


  end
end
