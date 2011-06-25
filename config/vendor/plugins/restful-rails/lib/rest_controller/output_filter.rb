require 'base64'
require 'digest/md5'

module RestController
  class OutputFilter

    def self.filter(controller)
      return if controller.response.body.nil?

      controller.response.headers['Content-Length'] = controller.response.body.length

      return if controller.response.headers['Content-Encoding']

      # TODO: add a flag that says if the Content-MD5 header is added or not

      # RFC 1864, section 2:
      #
      #   To generate the value of the Content-MD5 field, the MD5 algorithm is
      #   computed on the canonical form of the MIME entity's object.  In
      #   particular, this means that the sender applies the MD5 algorithm on
      #   the data immediately after conversion to canonical form, before
      #   applying any content-transfer-encoding, and that the receiver also
      #   applies the MD5 algorithm on the canonical form, after undoing any
      #   content-transfer-encoding.  For textual data, this means the MD5
      #   algorithm must be computed on data in which the canonical form for
      #   newlines applies, that is, in which each newline is represented by a
      #   CR-LF pair.

      # transform body newlines to CR-LF, MD5 hash and Base64 encode
      controller.response.headers['Content-MD5'] = Base64.encode64(Digest::MD5.digest(controller.response.body.gsub(/(\A|[^\x0d])\x0a/, "\\1\x0d\x0a"))).chomp

      controller.logger.info 'Added message integrity check Content-MD5 header: ' + controller.response.headers['Content-MD5']
    end

  end
end
