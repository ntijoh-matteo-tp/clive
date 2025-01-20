# frozen_string_literal: true

# abc
class Request
  def initialize(request_string)
    parse_request_lines(request_string)
    request_string_split = request_string.split("\n").drop(1)
    parse_headers(request_string_split)
    parse_params(request_string_split)

    #puts "Method: #{@method}", "Resource: #{@resource}", "Version: #{@version}", "Headers: #{@headers}",
    #     "Params: #{@params}"
  end
  
  attr_reader :method, :resource, :version, :headers, :params

  def map_params(params)
    params.map do |item|
      item = item.split('=')
      @params[item[0]] = item[1]
    end
  end

  def parse_request_lines(request_string)
    @method, @resource, @version = request_string.split(' ')
  end

  def parse_headers(request_string_split)
    @headers = {}

    request_string_split.map do |item|
      break if item == ''

      item = item.split(': ')
      @headers[item[0]] = item[1]
    end
  end

  def parse_params(request_string_split)
    @params = {}

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
  end

  private :map_params, :parse_headers, :parse_params, :parse_request_lines
end