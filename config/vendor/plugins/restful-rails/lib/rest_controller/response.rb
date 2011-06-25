module ActionController
  class AbstractResponse
    class ETagParserError < StandardError; end

    attr_reader :allowed_methods, :vary

    alias_method :initialize_without_vary, :initialize

    def initialize
      initialize_without_vary
      write_header('Status', HTTP::Status::DEFAULT)
      @allowed_methods = AllowedMethods.new(self)
      @vary            = Vary.new(self)
    end

    def status
      read_header('Status')
    end

    def status=(s)
      write_header('Status', s)
    end

    def status_code
      HTTP::Status.parse(status)[0]
    end

    def status_code=(code)
      self.status = code.to_s + ' ' + HTTP::Status.reason_phrase(code)
    end

    def reason_phrase
      HTTP::Status.reason_phrase(status_code)
    end

    def reason_phrase=(reason)
      self.status = HTTP::Status.status_code(reason).to_s + ' ' + reason
    end

    def info?
      HTTP::Status.info?(status_code)
    end

    def entity?
      HTTP::Status.entity?(status_code)
    end

    def success?
      HTTP::Status.success?(status_code)
    end

    def redirect?
      HTTP::Status.redirect?(status_code)
    end

    def client_error?
      HTTP::Status.client_error?(status_code)
    end

    def server_error?
      HTTP::Status.server_error?(status_code)
    end

    def error?
      HTTP::Status.error?(status_code)
    end

    def etag
      # TODO: make the ETag an object that knows how to parse an
      #       entity tag string, as well as do weak and strong
      #       comparisons based on the context.
      if e = read_header('ETag')
        is_weak, entity_tag = parse_etag(e)
        format_etag(is_weak, entity_tag)
      end
    rescue ETagParserError
      nil
    end

    def etag=(e)
      is_weak, entity_tag = parse_etag(e)
      write_header('ETag', format_etag(is_weak, entity_tag))
    rescue ETagParserError
      write_header('ETag', nil)
    end

    def last_modified
      if date = read_header('Last-Modified')
        lm = Time.httpdate(date) rescue nil
        lm && lm <= Time.now ? lm : nil  # date must not be in the future
      end
    end

    def last_modified=(lm)
      write_header('Last-Modified', lm.httpdate)
    rescue
      write_header('Last-Modified', nil)
    end

    def content_type
      read_header('Content-Type')
    end

    def content_type=(ct)
      write_header('Content-Type', ct)
    end

    def content_language
      read_header('Content-Language')
    end

    def content_language=(cl)
      write_header('Content-Language', cl)
    end

    def allowed_methods=(am)
      @allowed_methods = multi_value_header(AllowedMethods, AllowedMethods::InvalidError, am)
    end

    def vary=(v)
      @vary = multi_value_header(Vary, Vary::InvalidError, v)
    end

    class MultiValueHeader
      def initialize(header_name, response, value=nil)
        @header_name, @response = header_name, response
        clear!
        push(value) if value
      end

      def clear!
        response.headers.delete(header_name)
      end

      def push(args=[])
        if args.size > 0
          response.headers[header_name] = [ response.headers[header_name].to_s.split(','), args ].flatten.compact.uniq.join(',')
        end
      end

      private
        attr_reader :header_name, :response
    end

    class AllowedMethods < MultiValueHeader
      class InvalidError < StandardError; end

      def initialize(*args)
        super('Allow', *args)
      end

      def push(methods=[])
        super(methods.flatten.map { |m| m.to_s.upcase })
      end

      alias_method '<<', :push
    end

    class Vary < MultiValueHeader
      class InvalidError < StandardError; end

      def initialize(*args)
        super('Vary', *args)
      end

      def push(headers=[])
        return if response.headers[header_name] == '*' || headers.size == 0
        if headers.include?('*')
          clear!
          super('*')
        else
          super(headers)
        end
      end

      alias_method '<<', :push
    end

    private
      def parse_etag(e)
        if e && match = e.to_s.match(/\A(W\/)?"?([^"]+?)"?\z/)
          is_weak, entity_tag = match.captures
        end
        raise ETagParserError unless entity_tag && entity_tag.length > 0
        return is_weak.to_s, entity_tag
      end

      def format_etag(is_weak, entity_tag)
        # TODO: use the content-type to differentiate two representations from the same resource
        # TODO: hash the entity_tag with the content-type to make an opaque Entity Tag
        is_weak + '"' + entity_tag + '"'
      end

      def multi_value_header(object_class, error_class, value)
        case value
          when object_class  : value
          when Array, String : object_class.new(self, value)
          else                 raise error_class
        end
      end

      def read_header(header_name)
        headers[header_name]
      end

      def write_header(header_name, header_value)
        if header_value
          headers[header_name] = header_value
        else
          headers.delete(header_name)
        end
      end
  end
end
