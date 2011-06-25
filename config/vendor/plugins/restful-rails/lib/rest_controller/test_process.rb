# To ensure that our HTTP methods are used instead of the
# ActionController's methods, require the ActionController's file now
# so that we can override it.

require 'action_controller/test_process'

class Test::Unit::TestCase
  HTTP::METHODS.each do |method|
    method = method.to_s
    class_eval <<-EOV, __FILE__, __LINE__
      def #{method}(action, parameters = nil, session = nil, flash = nil)
        # Have the standard tests work by resetting the HTTP status
        # for each request, otherwise, if there is a test that
        # specifically fails, then any successive tests that succeed
        # will still have a failure HTTP status.
        @response.send(:write_header, 'Status', HTTP::Status::DEFAULT)

        @request.env['REQUEST_METHOD'] = "#{method.upcase}" if @request
        process(action, parameters, session, flash)
      end
    EOV
  end

  def assert_allowed_methods(*methods)
    allow = @response.headers['Allow'].split(/\s*,\s*/)
    methods.each do |method|
      assert allow.include?(method.to_s.upcase), "#{method.to_s.upcase} method is not allowed, but should be"
    end
  end

  def assert_disallowed_methods(*methods)
    allow = @response.headers['Allow'].split(/\s*,\s*/)
    methods.each do |method|
      assert !allow.include?(method.to_s.upcase), "#{method.to_s.upcase} method is allowed, but should not be"
    end
  end

  def assert_no_entity
    assert_template nil, 'Expected no template to be rendered'
    assert_nil @response.body, 'Expected response body to be empty'

    # None of the entity headers should be set
    (%w{ ETag Last-Modified } + %w{ Encoding Language Length Location MD5 Range Type }.map { |h| 'Content-' + h }).each do |header|
      assert_nil @response.headers[header], "Expected #{header} header to not be set"
    end
  end

  def assert_location(*options)
    assert_equal @controller.url_for(*options), @response.headers['location']
  end
end
