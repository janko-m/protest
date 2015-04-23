### v0.5.4

* Added list of pending tests, failed tests and errors to summary report.
* Added `Protest.fail_early` option.

### v0.5.3

* Stop running tests and display summary on ^C.

### v0.5.2

* Use existing error code if `exit` has been called.

### v0.5.1

* Fixed exit status code.

### v0.5.0

* Added ability of defining the report to be used in the `PROTEST_REPORT`
  environment variable.
* `Documentation` is the new default report.
* Deprecated `global_setup` and `global_teardown` methods.
* Deprecated `before` and `after` aliases for `setup` and `teardown`.
* Deprecated `story` and `scenario` aliases.
* Removed `Stories` report.
* Removed `Protest::Stories` module.
* Refactored reports.
* Modified Summaries module to include the full filtered backtrace in all reports.
