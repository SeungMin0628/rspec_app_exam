module WindowMacros
  def work_in_new_tab
    window = page.driver.browser.window_handles

    if window.size > 1 
      page.driver.browser.switch_to.window(window.last)

      yield

      page.driver.browser.close
      page.driver.browser.switch_to.window(window.first)
    end
  end
end