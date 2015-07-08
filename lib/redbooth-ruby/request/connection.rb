require 'net/http/post/multipart'

module RedboothRuby
  module Request
    # Connection class
    class Connection
      include Helpers
      attr_reader :access_token, :request_data

      def initialize(request_info)
        @info = request_info
        @session = @info.session if @info
        @access_token = @info.session.access_token if @session
      end

      def request
        return unless access_token
        case
        when use_body_file?
          multipart_request
        when download_file?
          download_file_with_redirect
        else
          access_token.send(*request_data)
        end
      end

      # Downloads the desired file following redirects to
      # amazon s3 without authentication headers
      #
      def download_file_with_redirect
        max_redirects = access_token.options.fetch(:max_redirects, 20)
        response = access_token.send(
          :get,
          URI.encode(api_url),
          redirect_count: max_redirects + 1
        )
        return response unless [302, 301].include? response.status

        url = response.headers['Location']
        uri = URI.parse(url)
        http = download_http(uri)
        http.start do |inner_http|
          download_file(uri, inner_http)
        end
      end

      # Generate a download http from a URI
      #
      # @param [URI] uri The URI to use
      def download_http(uri)
        http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = RedboothRuby.configuration[:use_ssl]
        http
      end

      # Download a file using different strategies
      #
      # @param [URI] uri The URI to use
      # @param [Net::HTTP] http The http to use
      # @return [Mixed] The downloaded file or the result of the download
      def download_file(uri, http)
        if @info.options.key?(:download_path)
          download_to_path(uri, http, @info.options[:download_path])
        else
          http.request(Net::HTTP::Get.new(uri))
        end
      end

      # Download a file to a path
      #
      # @param [URI] uri The URI to use
      # @param [Net::HTTP] http The http to use
      # @param [String] path The path to save the file to
      # @return [Mixed] The result of the operation
      def download_to_path(uri, http, path)
        request = Net::HTTP::Get.new uri

        http.request request do |response|
          open path, 'w' do |io|
            response.read_body do |chunk|
              io.write chunk
            end
            io.write "\n"
          end
        end
      end

      def set_request_data
        @request_data = []
        @request_data << @info.http_method if @info
        @request_data << api_url
        @request_data << { body: body_hash } unless use_url_params?
      end

      protected

      # Performs a multipart request by containing given files and post data
      #
      # @return [Http::Request]
      def multipart_request
        ::File.open(body_file_attrs[:local_path]) do |file|
          req = Net::HTTP::Post::Multipart.new(
            api_url,
            body_hash.merge(
              'asset' => UploadIO.new(
                file,
                'application/octet-stream',
                body_file_attrs[:name]
              )
            )
          )
          req['Authorization'] = "Bearer #{access_token.token}"
          # access_token.sign! req
          if RedboothRuby.configuration[:use_ssl]
            http = Net::HTTP.new(
              RedboothRuby.configuration[:api_base],
              Net::HTTP.https_default_port
            )
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            http.use_ssl = RedboothRuby.configuration[:use_ssl]
          else
            domain, port = RedboothRuby.configuration[:api_base].split(':')
            http = Net::HTTP.new(domain, port || Net::HTTP.http_default_port)
          end
          http.start do |inner_http|
            inner_http.request(req)
          end
        end
      end

      # Body params hash
      #
      # @return [Hash]
      def body_hash
        return {} unless @info
        @info.data
      end

      # Json encoded body
      #
      # @return [String]
      def body_json
        return '' unless body_hash
        JSON.generate(body_hash)
      end

      def body_file_attrs
        body_hash[:asset_attrs] || {}
      end

      # Body params url encoded
      #
      # @return [String]
      def encoded_www_body
        return '' unless body_hash
        URI.encode_www_form(body_hash)
      end

      def use_body_file?
        return false if use_url_params?
        body_hash.key?(:asset)
      end

      def download_file?
        return false unless @info
        @info.http_method == :download
      end

      def use_url_params?
        return false unless @info
        case @info.http_method
        when :post, :put
          false
        else
          true
        end
      end

      # Returns the api url for this request or default
      def api_url
        url =  "#{ api_url_method}#{api_url_domain }"
        url += "#{ RedboothRuby.configuration[:api_base] }"
        url += "#{ api_url_path }#{ api_url_version }"
        if @info
          url += @info.url
          url += '?' + encoded_www_body if use_url_params? &&
                                           !body_hash.empty?
        end
        url
      end

      def api_url_method
        if RedboothRuby.configuration[:use_ssl]
          'https://'
        else
          'http://'
        end
      end

      def api_url_domain
        return '' unless domain
        "#{ domain }."
      end

      def api_url_path
        return '' unless RedboothRuby.configuration[:api_base_path]
        "/#{RedboothRuby.configuration[:api_base_path]}"
      end

      def api_url_version
        return '' unless RedboothRuby.configuration[:api_version]
        "/#{RedboothRuby.configuration[:api_version]}"
      end

      # Returns the domain for the current request or the default one
      def domain
        return @info.subdomain if @info
        RedboothRuby.configuration[:domain_base]
      end
    end
  end
end
