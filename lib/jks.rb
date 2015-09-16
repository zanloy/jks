require 'openssl'

module OpenSSL
  module X509
    class Certificate
      def days_left
        (self.not_after - Time.now).to_i / (24 * 60 * 60)
      end
    end
  end
end

class JKS

  attr_accessor :keytool, :storepass
  attr_reader :certs

  def initialize(filename, storepass, keytool = nil, process = true)
    @keytool = keytool ? keytool : 'keytool'
    @filename = filename
    @storepass = storepass
    @certs = []
    self.process if process
  end

  def process
    keytoolcmd = "#{@keytool} -keystore #{@filename} -storepass #{@storepass} -list -rfc"
    filtercmd = "awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/'"
    result = `#{keytoolcmd} | #{filtercmd}`
    result.scan(/(?=-----BEGIN CERTIFICATE-----)(.*?)(?<=-----END CERTIFICATE-----)/m).each do |pem| 
      p pem
      cert = OpenSSL::X509::Certificate.new(pem.first)
      @certs << cert
    end
  end

end
