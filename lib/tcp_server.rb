require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

class HTTPServer

    def initialize(port)
        @port = port
    end

    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"
        router = Router.new

        router.add_route(:get, "/") do
            File.read("../test/example_requests/index.html")
        end
        router.add_route(:get, "/banan") do
            "<h1> banan </h1>"
        end
        router.add_route(:get, "/senap") do
            "<h1> senap </h1>"
        end
        router.add_route(:get, "/examples") do
            "<h1> examples </h1>"
        end


        #get("/banan") do
        #end

        while session = server.accept
            data = ""
            while line = session.gets and line !~ /^\s*$/
                data += line
            end
            puts "RECEIVED REQUEST"
            puts "-" * 40
            puts data
            puts "-" * 40

            request = Request.new(data)
            route = router.match_route(request)
            if route
                status = 200
                p route
                html = route[:block].call
            else
                status = 404
                html = "failerald ✂✂✂"
            end
            
            
            #Sen kolla om resursen (filen finns)

            # Nedanstående bör göras i er Response-klass

            response = Response.new(status, html, session)
            response.send
        end
    end
end

server = HTTPServer.new(4567)
server.start