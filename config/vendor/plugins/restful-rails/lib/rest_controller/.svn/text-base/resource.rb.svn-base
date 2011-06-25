module RestController
  class Resource
    attr_accessor :allowed_methods

    def initialize(controller, request)
      raise HTTP::NotImplementedError unless HTTP::METHODS.include?(request.method)
      @controller, @request, @allowed_methods = controller, request,  [ :get, :head, :options ]
    end

    def method_missing(http_method, cache_options = {}, &block)
      raise RestController::UnknownMethod unless HTTP::METHODS.include?(http_method)

      @allowed_methods << http_method

      return unless @request.method == http_method

      # test if conditional response possible
      @controller.send(:test_for_conditional_request!) unless @controller.send(:performed?)

      # set caching headers
      set_cache_headers(cache_options)

      # execute the per-method handler
      @controller.instance_eval(&block) if block_given?
    end

    private

      def set_cache_headers(options)
        cache_options = { 'private' => false, options[:cache_as].to_s => true }

        # Set the pre/post check values
        if options[:between]
          cache_options['post-check'] = options[:between].first
          cache_options['pre-check']  = options[:between].last
        else
          cache_options['post-check'] = options[:min] if options[:min]
          cache_options['pre-check']  = options[:max] || options[:for]
        end

        # Set the Expires, Date and Cache-Control headers to enable caching
        if cache_options['pre-check']
          @controller.send(:expires_in, cache_options['pre-check'], cache_options)

          # Keep the Date and Expires time difference in sync with Cache-Control max-age
          now = Time.now
          @controller.response.headers['Date'] = now.httpdate
          @controller.response.headers['Expires'] = (now + cache_options['pre-check'].to_i).httpdate
        end
      end
  end
end
