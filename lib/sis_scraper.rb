require 'sis_scraper.rb'

class SISScraper
  ALPHA = ('A'..'Z').to_a
  SIS = 'https://sisguest.case.edu'.freeze
  SEM_LIST_POS = 1 # position of the select list that determines the semester
  LEN_DEPT_NAME = 4	# Standard length of a department abbreviation

  # All the seemingly somewhat randomly generated strings for SIS's HTML ids for grabbing elements
  DEPT_BUTTONS_CLASS = 'PSEDITBOX_DISPONLY'.freeze
  DAYS_WEEK_SELECT_LIST_ID = 'SSR_CLSRCH_WRK_INCLUDE_CLASS_DAYS$6'.freeze
  SEARCH_CLASSES_ID = 'CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH'.freeze
  SIS_PROCESSING_ID = 'processing'.freeze
  NO_RESULTS_ID = 'DERIVED_CLSMSG_ERROR_TEXT'.freeze

  def initialize(download_dir)
    @download_dir = download_dir
    @browser = Watir::Browser.new :firefox
  end

  def download_all_sis_data
    go_to_sis
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
    @browser.goto SIS
  end

  def get_all_depts
    @browser.a(text: "select subject").when_present.click
    wait_while_sis_processing
    depts = []
    ALPHA.each do |letter|
      @browser.span(text: letter).a.when_present.click
      sleep(4) # arbitrary to satisfy SIS finickiness.
      depts += @browser.spans(class: DEPT_BUTTONS_CLASS).collect { |dept| dept.text if dept.text.length == LEN_DEPT_NAME }.keep_if { |dept| !dept.nil? }
    end
    @browser.a(text: 'Close').click
    wait_while_sis_processing
    depts
  end

  def get_all_semesters
    @browser.select_lists[SEM_LIST_POS].text.split("\n")
  end

  def search_for_classes(dept, semester)
    validate_on_search_criteria_page
    set_dept(dept)
    set_semester(semester)
    include_all_days_of_week
    search
    puts "Searching #{dept} for #{semester} semester"
    wait_while_sis_processing
  end

  def set_dept(dept)
    # Clear the text_field if there is still something there.
    4.times { @browser.inputs(type: 'text').first.when_present.send_keys(:backspace) }
    @browser.inputs(type: 'text').first.when_present.send_keys(dept)
  end

  def set_semester(semester)
    @browser.select_lists[SEM_LIST_POS].select(semester.strip)
  end

  def include_all_days_of_week
    @browser.select_list(id: DAYS_WEEK_SELECT_LIST_ID).when_present.select("include any of these days")
    @browser.inputs(type: "checkbox")[1..7].each { |box| box.click unless box.checked? }
  end

  def search
    # uses id to distinguish from menu bar search
    @browser.a(id: SEARCH_CLASSES_ID).when_present.click
  end

  def validate_on_search_criteria_page
    @browser.body.text.include? "Search for Classes"
  end

  def wait_while_sis_processing
    @browser.img(id: SIS_PROCESSING_ID).wait_while_present
  end

  def ok_more_than_20_results
    wait_while_sis_processing
    if @browser.span(id: 'DERIVED_SSE_DSP_SSR_MSG_TEXT').present?
      @browser.button(text: "OK").when_present.click
      @browser.button(text: "OK").wait_while_present
      wait_while_sis_processing
    end
  end

  def validate_on_course_list_page
    @browser.td(text: /The following classes match your search criteria/).present?
  end

  def downloadable?
    # Check for download icon
    @browser.img(title: 'Download').present?
  end

  def download_course_info(dept, semester)
    # Download courses
    @browser.img(title: 'Download').when_present.click
    sleep(2) # Arbitrary sleep sacrifice to satisfy SIS's finicky behavior
    # Rename the file to [DEPT]_[SEMESTER]
    new_file_name = "#{@download_dir}#{dept}_#{semester}.xls".strip
    default_file_name = "#{@download_dir}ps.xls"
    File.rename(default_file_name, new_file_name) if File.exists?(default_file_name)
  end

  def start_a_new_search
    @browser.a(text: 'Start a New Search').when_present.click
    wait_while_sis_processing
  end

  def clear_search_criteria
    @browser.a(text: 'Clear').when_present.click
    wait_while_sis_processing
  end

  def results?
    !@browser.span(id: NO_RESULTS_ID).present?
  end
end
