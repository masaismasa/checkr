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
  
  #訪問先アドレス
  site_config("http://myhome.nifty.com/rent/tokyo/adachiku/oyata")
  driver_setting
    
  # アクセス
  visit('')
  
  #検索条件を下記で指定
  select('賃料が安い順', :from => 'sort1')
  qwery_price = '10万円以上'
  select(qwery_price, :from => 'r1')
  check "r20-3"
  
  sleep 3 
  #tableのtbodyを取得し、内部のtrを配列で取得
  contents = find('#searchResultList > tbody').all('tr')
  
  # ループで要素を取り出す
  # header1 要素3の倍数なので、each_with_indexを使って余１を抽出
  contents.each_with_index do |content, n|
    if n % 3 == 1
      #とりあえず要素をテキスト化
      p content.text
      #後でこのなかで要素を取得
    end
  end

end
end
