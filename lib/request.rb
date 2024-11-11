# frozen_string_literal: true

# abc
class Request
  attr_reader :method, :resource, :version, :headers, :params

  def initialize(requeststring)

    @method, @resource, @version = requeststring.split(' ')
    @headers = {}
    request_string_split = requeststring.split("\n").drop(1)
    request_string_split.map do |item|
      break if item == ''

      item = item.split(' ')
      @headers[item[0].chomp(':')] = item[1]
    end

    @params = {}
    def map_params(params)
      params.map do |item|
        item = item.split('=')
        @params[item[0]] = item[1]
      end
    end

    # Params in resource
    if @resource.include?('?')
      params = @resource.split('?').drop(1)
      params = params[0].split('&')
      map_params(params)
    end

    # Params at bottom
    if request_string_split.include?('')
      params = request_string_split[-1].split('&')
      map_params(params)
    end

    puts "Method: #{@method}", "Resource: #{@resource}", "Version: #{@version}", "Headers: #{@headers}",
         "Params: #{@params}"
  end
end

request_string = File.read('../test/example_requests/post-login.request.txt')
request = Request.new(request_string)