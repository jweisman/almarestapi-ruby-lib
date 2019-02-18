require 'rest-client'
require 'json'
require 'nokogiri'


module AlmaRestApi
  class << self

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end      

    def get(uri)
      begin
        response = 
         RestClient.get uri(uri),
            accept: :json, 
            authorization: 'apikey ' + AlmaRestApi.configuration.api_key
        return JSON.parse(response.body)
      rescue => e
        raise parse_error e.response
      end 
    end
    
    def put(uri, data)
      begin
        response =
         RestClient.put uri(uri),
          data.to_json,
          accept: :json, 
          authorization: 'apikey ' + AlmaRestApi.configuration.api_key,
          content_type: :json
        return JSON.parse(response.body)   
      rescue => e
        raise parse_error e.response
      end 
    end
    
    def post(uri, data)
      begin
        response =
         RestClient.post uri(uri),
          data.to_json,
          accept: :json, 
          authorization: 'apikey ' + AlmaRestApi.configuration.api_key,
          content_type: :json
        return JSON.parse(response.body)  
      rescue => e
        raise parse_error e.response
      end         
    end 
    
    def delete(uri)
      begin
        RestClient.delete uri(uri),
          authorization: 'apikey ' + AlmaRestApi.configuration.api_key
      rescue => e
       raise parse_error e.response
      end   
    end 

    def uri(uri)
      if uri.start_with? 'http'
        return uri
      else
        return AlmaRestApi.configuration.api_path + uri
      end
    end

    def parse_error(err)
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
    end
  end 
end

class Configuration
  attr_accessor :api_key
  attr_accessor :api_path

  def initialize
    @api_key = ENV['ALMA_API_KEY']
    @api_path = ENV['ALMA_API_PATH'] || "https://api-na.hosted.exlibrisgroup.com/almaws/v1"
  end
end
