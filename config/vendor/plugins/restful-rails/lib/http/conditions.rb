require 'digest/md5'

module HTTP
  class Conditions
    def initialize(request, response)
      @request, @response, @models = request, response, []
    end

    def clear!
      @models.clear
    end

    def push(*models)
      @models.push(models)
    end

    alias_method '<<', :push

    def test!
      return unless @models.size > 0
      return unless response.status_code == HTTP::Status::OK

      lock_versions, updated_at_dates = [], []

      @models.flatten.each do |model|
        collection = model.respond_to?(:each) ? model : [ model ]
        collection.each do |m|
          locking_column = m.class.locking_column
          lock_versions    << "#{m.class}:#{m.id}:#{m.send(locking_column)}" if m.respond_to?(locking_column)
          updated_at_dates << m.updated_at                                       if m.respond_to?(:updated_at)
        end
      end

      response.etag          = Digest::MD5.hexdigest(lock_versions.join('|'))
      response.last_modified = updated_at_dates.compact.sort.last || Time.now

      raise HTTP::PreconditionFailedError                                                          unless match? || unmodified_since?
      return                                                                                           if none_match? && !modified_since?
      raise request.get? || request.head? ? HTTP::NotModifiedError : HTTP::PreconditionFailedError unless none_match?
      raise HTTP::NotModifiedError                                                                 unless modified_since?
    end

    def test?
      test!
      true
    rescue HTTP::Error
      false
    end

    def match?
      return true unless match = request_header('If-Match')

      # If-Match tests can only be done with strong etags
      try_match = response.etag[0,2] != 'W/' rescue false

      # - If-Match is *, return true if there is a defined ETag
      # - ETag is nil and would not be found in If-Match, return false
      # - ETag and If-Match test is allowed, return true if matched
      case
        when match == '*'          : response.etag != nil
        when response.etag  == nil : false
        when try_match             : match.strip.split(/\s*,\s*/).include?(response.etag)
        else                         false
      end
    end

    def none_match?
      return true unless none_match = request_header('If-None-Match')

      # For GET/HEAD requests without a Range header If-None-Match tests
      # may be done with either strong or weak etags.  For all other methods
      # strong etags must be used in tests
      try_match = request.get? && !request_header('Range') ? true : response.etag[0,2] != 'W/' rescue false

      # - If-None-Match is *, return true if there is a nil ETag
      # - ETag is nil and would not be found in If-None-Match, return true
      # - ETag and If-Match test is allowed, return true if not matched
      case
        when none_match == '*'    : response.etag == nil
        when response.etag == nil : true
        when try_match            : ! none_match.strip.split(/\s*,\s*/).include?(response.etag)
        else                        false
      end
    end

    def modified_since?
      return true unless response.last_modified && modified_since = request_header('If-Modified-Since')
      response.last_modified > modified_since
    end

    def unmodified_since?
      return true unless response.last_modified && unmodified_since = request_header('If-Unmodified-Since')
      response.last_modified <= unmodified_since
    end

   private

     attr_reader :request, :response

      def request_header(header_name)
        response.vary << header_name
        method = header_name.tr('-', '_').downcase
        request.send(method)
      end
  end
end
