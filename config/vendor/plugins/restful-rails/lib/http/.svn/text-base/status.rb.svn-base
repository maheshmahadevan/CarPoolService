module HTTP
  module Status
    DEFAULT = '200 OK'

    # HTTP Status Codes
    CODES = {
      'Continue'                      => 100,
      'Switching Protocols'           => 101,
      'Processing'                    => 102,
      'OK'                            => 200,
      'Created'                       => 201,
      'Accepted'                      => 202,
      'Non-Authoritative Information' => 203,
      'No Content'                    => 204,
      'Reset Content'                 => 205,
      'Partial Content'               => 206,
      'Multi Status'                  => 207,
      'Multiple Choices'              => 300,
      'Moved Permanently'             => 301,
      'Found'                         => 302,
      'See Other'                     => 303,
      'Not Modified'                  => 304,
      'Use Proxy'                     => 305,
      'Temporary Redirect'            => 307,
      'Bad Request'                   => 400,
      'Unauthorized'                  => 401,
      'Payment Required'              => 402,
      'Forbidden'                     => 403,
      'Not Found'                     => 404,
      'Method Not Allowed'            => 405,
      'Not Acceptable'                => 406,
      'Proxy Authentication Required' => 407,
      'Request Timeout'               => 408,
      'Conflict'                      => 409,
      'Gone'                          => 410,
      'Length Required'               => 411,
      'Precondition Failed'           => 412,
      'Request Entity Too Large'      => 413,
      'Request-URI Too Large'         => 414,
      'Unsupported Media Type'        => 415,
      'Request Range Not Satisfiable' => 416,
      'Expectation Failed'            => 417,
      'Unprocessable Entity'          => 422,
      'Locked'                        => 423,
      'Failed Dependency'             => 424,
      'Internal Server Error'         => 500,
      'Not Implemented'               => 501,
      'Bad Gateway'                   => 502,
      'Service Unavailable'           => 503,
      'Gateway Timeout'               => 504,
      'HTTP Version Not Supported'    => 505,
      'Insufficient Storage'          => 507
    }

    # Define the HTTP Status Code constants
    CODES.each do |reason_phrase,status_code|
      const_set(reason_phrase.tr_s('- ', '_').upcase, status_code)
    end

    class << self
      def info?(status_code)
        (100..199).include?(status_code)
      end

      def entity?(status_code)
        [ OK, CREATED, PARTIAL_CONTENT ].include?(status_code)
      end

      def success?(status_code)
        (200..299).include?(status_code)
      end

      def redirect?(status_code)
        (300..399).include?(status_code)
      end

      def client_error?(status_code)
        (400..499).include?(status_code)
      end

      def server_error?(status_code)
        (500..599).include?(status_code)
      end

      def error?(status_code)
        client_error?(status_code) || server_error?(status_code)
      end

      MATCH_STATUS_CODES = Regexp.new('\A(' + CODES.values.join('|') + ')\b')

      def parse(status)
        raise "Invalid status #{status}" unless code = status.match(MATCH_STATUS_CODES)[1].to_i
        return code, reason_phrase(code)
      end

      def reason_phrase(code)
        raise "Unknown status code #{code}" unless reason = HTTP::Status::CODES.invert[code]
        reason
      end

      def status_code(reason)
        raise "Unknown reason phrase #{reason}" unless code = HTTP::Constants::STATUS[reason]
        code
      end
    end
  end
end
