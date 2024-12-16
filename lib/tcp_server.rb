require 'socket'
require_relative 'request'

class HTTPServer

    def initialize(port)
        @port = port
    end

    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"
        router = Router.new

        router.add_route(:get, "/banan")
        router.add_route(:get, "/senap")


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
                html = "<h1>WOOT</h1>"
            else
                status = 404
                html = "failerald ✂✂✂"
            end
            
            
            #Sen kolla om resursen (filen finns)


            # Nedanstående bör göras i er Response-klasss

            session.print "HTTP/1.1 #{status}\r\n"
            session.print "Content-Type: text/html\r\n"
            session.print "\r\n"
            session.print html
            session.close
        end
    end
end

class Router
    initialize()

end
end

server = HTTPServer.new(4567)
server.start