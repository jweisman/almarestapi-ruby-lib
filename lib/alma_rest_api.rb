require 'rest-client'
require 'json'
require 'nokogiri'


module AlmaRestApi
  class << self

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end      

    def get(uri)
      check_config
      begin
        response = 
         RestClient.get uri(uri),
            accept: configuration.format,
            authorization: 'apikey ' + configuration.api_key
        if configuration.format == :"application/xml"
          return Nokogiri::XML.parse(response.body)
        else
          return JSON.parse(response.body)
        end
      rescue => e
        raise AlmaApiError, parse_error(e.response)
      end 
    end
    
    def put(uri, data)
      check_config
      begin
        response =
         RestClient.put uri(uri),
          configuration.format == :"application/xml" ? data.to_xml : data.to_json,
          accept: configuration.format,
          authorization: 'apikey ' + configuration.api_key,
          content_type: configuration.format
        if configuration.format == :"application/xml"
          return Nokogiri::XML.parse(response.body)
        else
          return JSON.parse(response.body)
        end
      rescue => e
        raise AlmaApiError, parse_error(e.response)
      end 
    end
    
    def post(uri, data)
      check_config
      begin
        response =
         RestClient.post uri(uri),
          configuration.format == :"application/xml" ? data.to_xml : data.to_json,
          accept: configuration.format,
          authorization: 'apikey ' + configuration.api_key,
          content_type: configuration.format
        if configuration.format == :"application/xml"
          return Nokogiri::XML.parse(response.body)
        else
          return JSON.parse(response.body)
        end
      rescue => e
        raise AlmaApiError, parse_error(e.response)
      end         
    end 
    
    def delete(uri)
      check_config
      begin
        RestClient.delete uri(uri),
          authorization: 'apikey ' + configuration.api_key
      rescue => e
       raise AlmaApiError, parse_error(e.response)
      end   
    end 

    def uri(uri)
      if uri.start_with? 'http'
        return uri
      else
        return AlmaRestApi.configuration.api_path + uri
      end
    end

    def check_config
      raise NoApiKeyError if configuration.api_key.nil? || configuration.api_key.empty?
      raise InvalidApiFormatError unless [:json, :"application/xml"].include? configuration.format
    end

    def parse_error(err)
      begin
        if err[0] == '<'
          msg = err.match(/<errorMessage>(.*)<\/errorMessage>/)
          return msg ? msg[1] : ''
        elsif err[0] == '{'
          begin
            error = JSON.parse(err)
            if error["web_service_result"] #500
              return error["web_service_result"]["errorList"]["error"]["errorMessage"]
            else #400
              return error["errorList"]["error"][0]["errorMessage"]
            end
          rescue JSON::ParserError
            return "Unknown error from Alma"
          end            
        else
          return err          
        end
      rescue
        return err
      end
    end
  end 
end

class Configuration
  attr_accessor :api_key
  attr_accessor :api_path
  attr_accessor :format

  def initialize
    @api_key = ENV['ALMA_APIKEY']
    @api_path = ENV['ALMA_APIPATH'] || "https://api-na.hosted.exlibrisgroup.com/almaws/v1"
    @format = ENV['ALMA_FORMAT'] || :json
  end
end

class NoApiKeyError < StandardError
  def initialize(msg="No API key defined")
    super
  end
end

class InvalidApiFormatError < StandardError
  def initialize(msg="API format must be :json or :\"application/xml\"")
    super
  end
end

class AlmaApiError < StandardError
  def initialize(msg)
    msg = "Unknown error from Alma" if msg.empty?
    super
  end
end
