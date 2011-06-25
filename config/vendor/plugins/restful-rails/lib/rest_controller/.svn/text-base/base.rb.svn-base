module RestController
  module Base
    def self.included(base)
      base.send(:alias_method, :process_without_rest, :process)
      base.send(:private, :process_without_rest)
      base.send(:alias_method, :process, :process_with_rest)
      base.extend(ClassMethods)
    end

    def process_with_rest(request, response, *arguments) #:nodoc:
      @conditions = HTTP::Conditions.new(request, response)
      @resource   = RestController::Resource.new(self, request)
      process_without_rest(request, response, *arguments)
    rescue HTTP::Error => e
      rescue_http_error(e)
    end

    module ClassMethods
      def resource(name, &block)
        define_method(name) do
          #@resource = RestController::Resource.new(self, request)  # uncomment once API is finalized
          instance_exec(@resource, &block) if block_given?
        end
      end
    end

    private

      attr_reader :conditions, :resource

      def test_for_conditional_request!
        conditions.test!
        true
      end

      def rescue_action(e)
        e.kind_of?(HTTP::Error) ? rescue_http_error(e) : super(e)
      end

      def rescue_http_error(e)
        case e
          when HTTP::NotModifiedError        : render_nothing         HTTP::Status::NOT_MODIFIED
          when HTTP::PreconditionFailedError : render_nothing         HTTP::Status::PRECONDITION_FAILED
          when HTTP::MethodNotAllowedError   : render_allowed_methods HTTP::Status::METHOD_NOT_ALLOWED
          when HTTP::NotImplementedError     : render_allowed_methods HTTP::Status::NOT_IMPLEMENTED
        end
      end

      def render(options = {})
        # send a Method Not Allowed if the method was not handled by the resource
        raise HTTP::MethodNotAllowedError unless resource.allowed_methods.include?(request.method)

        # Would prefer to have a hook to execute code after an
        # action but before render, but this'll have to do for now
        options[:status] ||= response.status_code

        if HTTP::Status.entity?(options[:status])
          # catch common methods if they were not handled in the action
          case request.method
            when :get, :head : test_for_conditional_request!
            when :options    : return render_allowed_methods
          end
        else
          # Do not send entity headers unless entity body is sent
          response.etag = nil
          response.last_modified = nil
        end

        super options
      end

      def render_nothing(*options)
        response.etag = nil
        response.last_modified = nil
        super *options
        response.body = nil
      end

      def render_allowed_methods(status = HTTP::Status::NO_CONTENT)
        expires_now
        response.allowed_methods = resource.allowed_methods
        render_nothing status
      end

      def render_post_success(*options)
        redirect_to *options
        response.status_code = HTTP::Status::CREATED
        response.body = nil
      end

      def render_put_success(*options)

        # As per RFC 2616, Section 14.7:
        # The Allow header field MAY be provided with a PUT request to
        # recommend the methods to be supported by the new or modified
        # resource. The server is not required to support these methods and
        # SHOULD include an Allow header in the response giving the actual
        # supported methods.
        response.allowed_methods = resource.allowed_methods

        render_nothing HTTP::Status::NO_CONTENT
      end

      def render_delete_success(options = {})
        render_nothing HTTP::Status::NO_CONTENT
      end
  end
end
