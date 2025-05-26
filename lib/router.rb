# Stores routes, handles their creation and matches them to incoming requests.
#
# @author Matteo Torquato Perillo
class Router

    # Initializes a Router object
    #
    # @return [Router] a new instance of Router
    def initialize()
        @routes = []
    end

    # Adds a route to the Router object using parameters from a HTTP request
    #
    # @param method [String] the HTTP request method, "GET" or "POST", of the route being added
    # @param resource [String] the URI of the route being added
    # @param block [Proc] the block of the route being added
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

    # Handles a GET request
    #
    # @param resource [String] the URI of the route
    # @param &block [Proc] the block of the route
    # @return [void]
    def get(resource, &block)
        add_route("get".upcase, resource, block)
    end
end