module CheckrsHelper
  
  def site_config(page)
    Capybara.configure do |config|
      config.run_server = false
      config.current_driver = :poltergeist
      config.javascript_driver = :poltergeist
      config.app_host = page
      config.default_max_wait_time = 5
    end
  end

  def driver_setting
    Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {timeout: 120, js_errors: false})
    end
  end
end
