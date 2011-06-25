module ActionController
  class AbstractRequest
    HTTP::METHODS.each do |m|
      name = m.to_s + '?'
      unless respond_to?(name)
        define_method(name) { method == m }
      end
    end

    attr_reader :headers

    def initialize(*args)
      super(*args)
      @headers = Hash.new { |h,k| h[k] = env['HTTP_' + k.tr('-', '_').upcase] }
    end

    def range
      headers['If-Match']
    end

    def if_match
      headers['If-Match']
    end

    def if_none_match
      headers['If-None-Match']
    end

    def if_modified_since
      header_date('If-Modified-Since')
    end

    def if_unmodified_since
      header_date('If-Unmodified-Since')
    end

    def get?
      # GET and HEAD requests should *never* be treated
      # differently by the controller
      method == :get || method == :head
    end

    alias_method :head?, :get?

    def remote_user
      env['REMOTE_USER']
    end

    def remote_user=(u)
      env['REMOTE_USER'] = u
    end

    def referer
      headers['Referer']
    end

    private
      def header_date(header_name)
        if date = headers[header_name]
          hd = Time.httpdate(date) rescue nil
          hd && hd <= Time.now ? hd : nil  # date must not be in the future
        end
      end
  end
end
