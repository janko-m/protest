module Protest
  # The +:summary+ report will output a brief summary with the total number
  # of tests, assertions, passed tests, pending tests, failed tests and
  # errors.
  #
  # It will also output the list of pending tests, failed tests and errors.
  class Reports::Summary < Report
    on :end do |report|
      report.summarize_pending_tests
      report.summarize_errors
      report.summarize_test_totals
    end
  end

  add_report :summary, Reports::Summary
end
