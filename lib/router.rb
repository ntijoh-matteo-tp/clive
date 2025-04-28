class Router
    def initialize()
        @routes = []
    end

    #def add_route(method, resource, &block)
    #    @routes.append({:method => method, :resource => resource, :block => block})
    #end
  
    def match_route(request)
        puts "Putsing routes"
        p @routes
        p @routes
        p @routes
        @routes.map do |route|
            puts "BEFORE splitting"
            p route[:resource]
            splitRouteResource = route[:resource].split("/")
            routeParamIndexes = []
            puts "AFTER spitting"

            p splitRouteResource
            i = 0
            while i < splitRouteResource.length
                if splitRouteResource[i][0] == ":"
                    routeParamIndexes.append(i)
                end
                i += 1
            end

            splitRequestResource = request.resource.split("/")

            puts "comparing:"
            p splitRouteResource
            puts "to"
            p splitRequestResource


            i = 0
            while i < splitRequestResource.length
                if routeParamIndexes.include?(i)
                    i += 1
                else
                    if splitRequestResource[i] == splitRouteResource[i]
                        i += 1
                    else
                        break
                    end
                end

                return route
            end

        end
    end

    def get(resource, &block)
        puts "getting"
        puts resource
        puts resource
        puts resource
        puts resource
        puts resource
        puts resource
        puts resource
        @routes.append({:method => "get", :resource => resource, :block => block})
    end
end