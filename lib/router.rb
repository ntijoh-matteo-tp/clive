class Router
  def initialize()
        @routes = []
  end

  def add_route(method, resource, &block)
      @routes.append({:method => method, :resource => resource, :block => block})
  end
  
  def match_route(request)
      @routes.map do |route|
          if [route[:method].to_s.upcase, route[:resource]] == [request.method, request.resource]
              return route
          end
      end

      return false
  end
end