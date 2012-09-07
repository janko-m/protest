# Protest [<img src="https://secure.travis-ci.org/matflores/protest.png?branch=master" alt="Build Status" />](http://travis-ci.org/matflores/protest)

```ruby
require "protest"

Protest.describe("A user") do
  setup do
    @user = User.new(:name => "John Doe", :email => "john@example.org")
  end

  it "has a name" do
    assert_equal "John Doe", @user.name
  end

  it "has an email" do
    assert_equal "john@example.org", @user.email
  end
end
```

Protest is a small, simple, and easy-to-extend testing framework for ruby. It
was written as a replacement for Test::Unit, given how awful its code is, and
how difficult it is to extend in order to add new features.

I believe in minimalistic software, which is easily understood, easy to test,
and specially, easy to extend for third parties. That's where I'm aiming with
Protest.

## Get it

```
gem install protest
```

## Setup and teardown

If you need to run code before or after each test, declare a `setup` or
`teardown` block:

```ruby
Protest.context("A user") do
  setup do # this runs before each test
    @user = User.create(:name => "John")
  end

  teardown do # this runs after each test
    @user.destroy
  end
end
```

`setup` and `teardown` blocks are evaluated in the same context as your test,
which means any instance variables defined in any of them are available in the
rest. Both methods are aliased for your comfort as `before` and `after` respectively.

## Nested contexts

Break down your test into logical chunks with nested contexts:

```ruby
Protest.describe("A user") do
  setup do
    @user = User.make
  end

  context "when validating" do
    it "validates name" do
      @user.name = nil
      assert !@user.valid?
    end

    # etc, etc
  end

  context "doing something else" do
    # you get the idea
  end
end
```

Any `setup` or `teardown` blocks you defined in a context will run in that
context and in _any_ other context nested in it.

## Pending tests

There are two ways of marking a test as pending. You can declare a test with no
body:

```ruby
Protest.context("Some tests") do
  test "this test will be marked as pending"

  test "this tests is also pending"

  test "this test isn't pending" do
    assert true
  end
end
```

Or you can call the `pending` method from inside your test:

```ruby
Protest.context("Some tests") do
  test "this test is pending" do
    pending "oops, this doesn't work"
    assert false
  end
end
```

## Custom assertions

Previous versions of Protest used to bundle all the assertions defined in
Test::Unit, but that has changed and now Protest includes just three basic
assertion methods:

- assert
- assert_equal
- assert_raise

If you want to add assertions, just define methods that rely on `assert`.
This method takes a boolean and an optional error message as arguments, and
the assertion is considered to fail if the boolean evaluates to neither
`false` nor `nil`.

For example:

```ruby
module AwesomenessAssertions
  def assert_awesomeness(object)
    assert object.awesome?, "#{object.inspect} is not awesome enough"
  end
end

class Protest::TestCase
  include AwesomenessAssertions
end
```

You could also define rspec-like matchers if you like that style. See
`matchers.rb` in the examples directory for an example.

## Reports

Protest can report the output of a test suite in many ways. The library ships
with a few reports defined by default.

You can select which report to use using the `report_with` method:

```ruby
Protest.report_with(:documentation)
Protest.report_with(:progress)
Protest.report_with(:my_awesome_custom_report)
```

By default, Protest will use the report defined in the `PROTEST_REPORT`
environment variable. If this variable is not defined, the Documentation
report will be used.

### Progress report

Use this report by calling `Protest.report_with(:progress)`.

The progress report will output the "classic" Test::Unit output of periods for
passing tests, "F" for failing assertions, "E" for unrescued exceptions, and
"P" for pending tests, in full color.

### Documentation report

Use this report by calling `Protest.report_with(:progress)`.

For each testcase in your suite, this will output the description of the test
case (whatever you provide TestCase.context), followed by the name of each test
in that context, one per line. For example:

```ruby
Protest.context "A user" do
  test "has a name"
  test "has an email"

  context "validations" do
    test "ensure the email can't be blank"
  end
end
```

Will output, when run with the `:documentation` report:

```
A user
- has a name (Not Yet Implemented)
- has an email (Not Yet Implemented)

A user validations
- ensure the email can't be blank (Not Yet Implemented)
```

(The 'Not Yet Implemented' messages are because the tests have no body. See
"Pending tests", above.)

This is similar to the specdoc runner in [rspec](http://rspec.info).

### Summary report

Use this report by calling `Protest.report_with(:summary)`.

This report will output a brief summary with the total number of tests,
assertions, passed tests, pending tests, failed tests and errors.

### Stories report

Use this report by calling `Protest.report_with(:stories)`.

This report is based on Citrusbyte's [Stories](http://github.com/citrusbyte/stories),
by Damian Janowski and Michel Martens.

### Turn report

Use this report by calling `Protest.report_with(:turn)`.

This report displays each test on a separate line with failures being displayed
immediately instead of at the end of the tests.

You might find this useful when running a large test suite, as it can be very
frustrating to see a failure (....F...) and then have to wait until all the
tests finish before you can see what the exact failure was.

This report is based on the output displayed by [TURN](http://github.com/TwP/turn),
Test::Unit Reporter (New) by Tim Pease.

### Defining your own reports

This is really, really easy. All you need to do is subclass `Report`, and
register your subclass by calling `Protest.add_report`. See the
documentation for details, or take a look at the source code for
`Protest::Reports::Progress` and `Protest::Reports::Documentation`.

## Using Rails?

If you are using Rails you may want to take a look at [protest-rails](http://github.com/matflores/protest-rails).

## Legal

* Maintainer: Matías Flores — http://matflores.com
* Author: Nicolás Sanguinetti — http://nicolassanguinetti.info
* License: MIT (see bundled LICENSE file for more info)