# Alma REST API Ruby Library

This library provides wrapper functions to call the Alma REST API.

## Configuration
alma_rest_api_init.rb in `config/initializers`
```
AlmaRestApi.configure do |config|
  config.api_key = "l7xx..."
end
```

OR via environment variables:
* `ALMA_API_KEY`  
* `ALMA_API_PATH` (default https://api-na.hosted.exlibrisgroup.com/almaws/v1)

## Usage

### irb

```
$ irb
irb(main):001:0> require 'alma_rest_api'
=> true
irb(main):002:0> AlmaRestApi.configuration.api_key="l7xx......"
=> "l7xx......"
irb(main):003:0> AlmaRestApi.get "/users/joshw?view=brief"
=> {"record_type"=>{"value"=>"PUBLIC", "desc"=>"Public"}, "primary_id"=>"joshw", "first_name"=>"Josh", ... }
```

### Rails

*controller*
```
require 'alma_rest_api'
  def show
    item = AlmaRestApi.get "/items?item_barcode=#{params[:id]}"
    respond_to do |format|
      format.json { render json: item }
    end
  end

  def update
    begin
      item = AlmaRestApi.put params[:link], params.slice(:item_data)
      render json: item
    rescue => e
      render json: { "error" => e.message }, :status => :bad_request
    end
  end  
```