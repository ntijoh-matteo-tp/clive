require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

class HTTPServer

    def initialize(port)
        @port = port
        @mime_types = {
            "html" => "text/html",
            "css" => "text/css",
            "js" => "application/javascript",
            "png" => "image/png",
            "jpg" => "image/jpeg",
            "jpeg" => "image/jpeg",
            "gif" => "image/gif",
            "svg" => "image/svg+xml",
            "json" => "application/json",
            "txt" => "text/plain"
        }
    end

    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"
        router = Router.new

        router.add_route(:get, "/") do
            File.read("./public/index.html")
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
                body = route[:block].call
                status = 200
                content_type = "text/html"
            elsif File.exist?("./public#{request.resource}")
                body = File.binread("./public#{request.resource}")
                p body
            else
                body = "<h1>epic fail</h1>"
                status = 404
                content_type = "text/html"
            end
            
            
            #Sen kolla om resursen (filen finns)

            # Nedanstående bör göras i er Response-klass

            response = Response.new(status, body, session)
            response.send
        end
    end
end

server = HTTPServer.new(4567)
server.start