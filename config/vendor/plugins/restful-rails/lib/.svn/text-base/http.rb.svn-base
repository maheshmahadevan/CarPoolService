#--
# Copyright (c) 2006 Dan Kubb <dan.kubb@autopilotmarketing.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module HTTP
  require 'http/authentication'
  require 'http/conditions'
  require 'http/status'

  class Error < StandardError; end
  class ConditionalError < Error; end
  class NotModifiedError < ConditionalError; end
  class MethodNotAllowedError < Error; end
  class PreconditionFailedError < ConditionalError; end
  class NotImplementedError < Error; end
  class UnauthorizedError < Error; end

  # Common HTTP methods
  METHODS = [ :get, :put, :post, :delete, :connect, :options, :trace, :patch, :propfind, :proppatch, :mkcol, :copy, :move, :lock, :unlock, :version_control, :checkout, :uncheckout, :checkin, :update, :label, :report, :mkworkspace, :mkactivity, :baseline_control, :merge ]
end
