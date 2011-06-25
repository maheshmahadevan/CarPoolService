# TODO: make it so that http authentication handlers can be plugged in
#       should be able to register themselves somehow.  The code below
#       is hard coded to only work with digest and basic well, but should
#       be extensible to work with weird auth schemes like WSSE

module HTTP
  module Authentication
    module Base

      def http_authenticate_for(realm, options, &block)
        raise HTTP::Authentication::NoAuthHeaderError unless auth_header = request.headers['Authorization']

        auth_type, auth_data = auth_header.split(' ', 2)
        type = (auth_type.downcase + '_auth').to_sym
        raise HTTP::Authentication::NotSupportedAuthTypeError unless options[:with].include?(type)
        send(type, auth_data, &block)

        return true
      rescue HTTP::Authentication::Error => error

        # TODO: raise an HTTP::UnauthorizedError exception instead

        # prompt the user agent to authenticate
        response.headers['WWW-Authenticate'] = response.headers['WWW-Authenticate'].to_a

        options[:with].each do |auth_type|
          case auth_type
          when :basic_auth
            response.headers['WWW-Authenticate'].push("Basic realm=\"#{realm}\"")
          when :digest_auth
            next  # XXX: skip digest for now
          when :wsse_auth
            next  # XXX: skip wsse for now
          end
        end

        response.status_code = 401

        if options[:render]
          (options[:render][:params] ||= {}).merge!({ :error => error })
          render_component options[:render]
        end

        return false
      end

      private

        def basic_auth(auth_data, &block)
          name, password = Base64.decode64(auth_data).split(':', 2)
          raise HTTP::Authentication::NoPasswordError   unless password.length > 0
          raise HTTP::Authentication::UserNotFoundError unless request.remote_user = yield(name, password, :plaintext)
        end

        def digest_auth(auth_data, &block)
          raise HTTP::Authentication::NotSupportedAuthTypeError, 'Digest authentication is not supported'
        end

        def wsse_auth(auth_data, &block)
          raise HTTP::Authentication::NotSupportedAuthTypeError, 'WSSE authentication is not supported'
        end
    end
  end
end
