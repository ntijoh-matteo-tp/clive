# frozen_string_literal: true

# @author Matteo Torquato Perillo
class Request

  # Initializes a Request object by parsing a HTTP request string and assigning each part to its respective attribute of the object.
  #
  # @param request_string [String] the string with the html request.
  # @return [Request] an instance of the object, a Request. 
  def initialize(request_string)
    parse_request_lines(request_string)
    request_string_split = request_string.split("\n").drop(1)
    parse_headers(request_string_split)
    parse_params(request_string_split)
  end
  
  attr_reader :method, :resource, :version, :headers, :params
  
  # (see #initialize)
  def parse_request_lines(request_string)
    tmp = request_string.split(' ') 

    @method, @resource, @version = request_string.split(' ')
  end

  # (see #initialize)
  def parse_headers(request_string_split)
    @headers = {}

    request_string_split.map do |item|
      break if item == ''

      item = item.split(': ')
      @headers[item[0]] = item[1]
    end
  end

  # (see #initialize)
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

  # (see #parse_params)
  # @note Maps the params array parsed from the request string.
  def map_params(params)
    params.map do |item|
      item = item.split('=')
      @params[item[0]] = item[1]
    end
  end

  private :map_params, :parse_headers, :parse_params, :parse_request_lines
end