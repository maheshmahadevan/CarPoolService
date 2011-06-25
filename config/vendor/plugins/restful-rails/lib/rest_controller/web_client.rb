module RestController
  module Base
    private
      [ :post, :put, :delete ].each do |http_method|
        new_method      = "render_#{http_method}_success"
        original_method = 'original_' + new_method
        alias_method original_method.to_sym, new_method.to_sym
        define_method(new_method) do |*options|
          see_other_if_tunneled_via_post(original_method, *options)
        end
      end

      def see_other_if_tunneled_via_post(original, *options)
        if request.tunneled_via_post?
          redirect_to *options
          response.status_code = HTTP::Status::SEE_OTHER
        else
          send(original, *options)
        end
      end

      def render_nothing(*options)
        response.etag = nil
        response.last_modified = nil
        super *options
        response.body = nil unless request.tunneled_via_post?
      end
  end
end

module ActionController
  class AbstractRequest
    alias_method :original_method, :method

    def post?
      original_method == :post
    end

    def method
      http_method = tunneled_via_post? ? tunneled_method : original_method
      http_method == :head ? :get : http_method
    end

    def tunneled_via_post?
      post? && tunneled_method
    end

    private
      def tunneled_method
        if %w{ application/x-www-form-urlencoded multipart/form-data }.include?(content_type.to_s.split(';').first)
          if tm = HTTP::METHODS.find { |m| parameters.has_key?('method_' + m.to_s) }
            return tm
          elsif parameters['method'] && tm = parameters['method'].downcase.to_sym
            return tm if HTTP::METHODS.include?(tm)
          end
        end
        nil
      end
  end
end
