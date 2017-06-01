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
      # result = Result .new
      # result.address = content.find()
      # result.save
      p content.text
      @contents << content.text
      end
    end
  
  render "checkrs/index"
  
  end
end
