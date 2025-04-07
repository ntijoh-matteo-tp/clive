class Router
    def initialize()
        @routes = []
    end

  #def add_route(method, resource, &block)
  #    @routes.append({:method => method, :resource => resource, :block => block})
  #end
  
    def match_route(request)
        @routes.map do |route|
            splitResource = request.resource.split("/").delete_at(0)
            i = 0
            while i < splitResource.length
                if splitResource[i].contains?(":")

            if request.resource == "/add/1/2" && route[:resource] == "/add/:num1/:num2"
                require 'debug'
                binding.break
            end
            if [route[:method].to_s.upcase, route[:resource]] == [request.method, request.resource]
                j = request.resource.count(":")
                if j > 0
                    i = 0
                    while i < j
                        i += 1
                    end
                return route
             end
        end

      return false
    end

    def get(resource, &block)
        @routes.append({:method => :get, :resource => resource, :block => block})
    end
end