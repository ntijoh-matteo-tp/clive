# @author Matteo Torquato Perillo
class Router

    # Initializes a Router object.
    #
    # @return [void]
    def initialize()
        @routes = []
    end

    # Adds a route to the Router object using parameters from a HTTP request
    #
    # @param method [String] the HTTP request method, "GET" or "POST"
    # @param resource [String] idk
    # @param block [Proc] idk
    # @return [void]
    def add_route(method, resource, block)
        splitResource = resource.split("/").drop(1)

        splitResource.map.with_index do |element, index|
            if element[0] == ":"
                splitResource[index] = {:regexp => /(\w+)/, :name => element[1..-1]}
            end
        end

        @routes.append({:method => method, :resource => splitResource, :block => block})
    end
  
    # Compares an HTTP request's resource with the resource of each route stored in the Router object, until a match is found.
    #
    # @param request [Request] the HTTP request
    # @return [Hash, Boolean] the route that matches the request, or false.
    def match_route(request)
        puts "Class real request: #{request.class}"
        @routes.each do |route|
            routeResource = route[:resource]
            requestResource = request.resource.split("/").drop(1)
            
            params = {}

            if routeResource.length == requestResource.length
                routeResource.each_with_index do |element, index|
                    if element.is_a?(String)
                        if element != requestResource[index] 
                            return false
                        end
                    elsif requestResource[index].match?(element[:regexp])
                        params[element[:name].to_sym] = requestResource[index]
                    end
                end

                request.params.merge!(params)
                return route
            end
        end

        return false
    end

    # idk
    #
    # @param resource [String] idk
    # @param &block [Proc] idk
    # @return [void]
    def get(resource, &block)
        add_route("get".upcase, resource, block)
    end

    # (see #get)
    def post(resource, &block)
        add_route("post".upcase, resource, block)
    end
end