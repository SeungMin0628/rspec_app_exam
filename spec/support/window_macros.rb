module WindowMacros
  def work_in_new_tab
    window = page.driver.browser.window_handles

    page.driver.browser.switch_to.window(window.last) if window.size > 1
  end
end