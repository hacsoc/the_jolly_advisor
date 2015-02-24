class SISScraper
  ALPHA = ('A'..'Z').to_a

  #TODO: This can be moved to configs later
  DOWNLOAD_DIR = '../../../Downloads/'

  def initialize()
    @browser = Watir::Browser.new :firefox
  end

  def download_all_sis_data(user,pword)
    go_to_sis
    sign_in_to_sis(user, pword)
    navigate_to_search_from_landing_page
    wait_while_sis_processing
    get_all_depts.each do |dept|
      get_all_semesters.each do |semester|
        sem = semester.strip
        search_for_classes(dept, sem)
        ok_more_than_20_results
        if results?
          if downloadable?
            download_course_info(dept, sem)
          else
            puts "#{dept}#{sem} needs manual input due to too few classes."
          end
          start_a_new_search
        else
          puts "#{dept}#{sem} had no classes."
        end
      end
    end
  end

  private

  def go_to_sis
    @browser = Watir::Browser.new
    @browser.goto "sis.case.edu"
  end

  def sign_in_to_sis(user, pword)
    # Sign In
    @browser.text_fields.first.wait_until_present
    @browser.text_fields.first.set user
    @browser.text_fields.last.wait_until_present
    @browser.text_fields.last.set pword
    @browser.button(:text => 'Sign In').click
  end

  def navigate_to_search_from_landing_page
    @browser.a(:text => 'Search').when_present.click
  end

  def iframe
    # Encapsulate browser with iframe
    @browser.iframe(:id => "ptifrmtgtframe").wait_until_present
    @browser.iframe(:id => "ptifrmtgtframe")
  end

  def get_all_depts
    iframe.a(:text => "select subject").when_present.click
    wait_while_sis_processing
    depts = []
    ALPHA.each do |letter|
      iframe.span(:text => letter).a.when_present.click
      sleep(4)
      depts += iframe.spans(:class => 'PSEDITBOX_DISPONLY').collect{|dept| dept.text if dept.text.length == 4}.keep_if{|dept| !dept.nil?}
    end
    iframe.a(:text => 'Close').click
    wait_while_sis_processing
    return depts
  end

  def get_all_semesters
    iframe.select_lists[2].text.split("\n")
  end

  def search_for_classes(dept,semester)
    validate_on_search_criteria_page
    set_dept(dept)
    set_semester(semester)
    include_all_days_of_week
    search
    puts "Searching #{dept} for #{semester} semester"
    wait_while_sis_processing
  end

  def set_dept(dept)
    #Clear the text_field if there is still something there.
    4.times{iframe.inputs(:type=> 'text').first.when_present.send_keys(:backspace)}
    iframe.inputs(:type=> 'text').first.when_present.send_keys(dept)
  end

  def set_semester(semester)
    iframe.select_lists[2].select(semester.strip)
  end

  def include_all_days_of_week
    iframe.select_list(:id => 'SSR_CLSRCH_WRK_INCLUDE_CLASS_DAYS$6').select("include any of these days")
    iframe.inputs(:type =>"checkbox")[1..7].each{|box| box.click unless box.checked?}
  end

  def search
    #uses id to distinguish from menu bar search
    iframe.a(:id => 'CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH').when_present.click
  end

  def validate_on_search_criteria_page
    iframe.body.text.include? "Search for Classes"
  end

  def wait_while_sis_processing
    iframe.img(:id => 'processing').wait_while_present
  end

  def ok_more_than_20_results
    wait_while_sis_processing
    if iframe.span(:id => 'DERIVED_SSE_DSP_SSR_MSG_TEXT').present?
      iframe.button(:text=>"OK").when_present.click
      iframe.button(:text => "OK").wait_while_present
      wait_while_sis_processing
    end
  end

  def validate_on_course_list_page
    iframe.td(:text => /The following classes match your search criteria/).present?
  end

  def downloadable?
    #Check for download icon
    iframe.img(:title => 'Download').present?
  end

  def download_course_info(dept,semester)
    #Download courses
    iframe.img(:title => 'Download').when_present.click
    sleep(2) #Arbitrary sleep sacrifice to satisfy SIS's finicky behavior

    #Rename the file to [DEPT]_[SEMESTER]
    new_file_name = "#{DOWNLOAD_DIR}#{dept}_#{semester}.xls".strip
    default_file_name = "#{DOWNLOAD_DIR}ps.xls"
    File.rename(default_file_name, new_file_name) if File.exists?(default_file_name)
  end

  def start_a_new_search
    iframe.a(:text => 'Start a New Search').when_present.click
    wait_while_sis_processing
  end

  def clear_search_criteria
    iframe.a(:text => 'Clear').when_present.click
    wait_while_sis_processing
  end

  def results?
    !iframe.span(:id => 'DERIVED_CLSMSG_ERROR_TEXT').present?
  end
end