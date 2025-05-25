require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

# @author Matteo Torquato Perillo
class HTTPServer

    # Initializes the HTTP server.
    #
    # @return [void]
    def initialize(port,router)
        @port = port
        @router = router
        
        #TODO: Egen klass?
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

    # Starts the HTTP server.
    #
    # @return [void]
    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"

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
            route = @router.match_route(request)
           
            puts "Resource: #{request.resource}"
            #request.resource != "" && request.resource != "/" && 

            puts "route: #{route}"
            puts "Route class:"

            puts "request resource: #{request.resource}"

            if route
                puts "We are now about to do the route block call."
                puts "Block: #{route[:block]}"
                body = route[:block].call(request.params)
                status = 200
                content_type = "text/html"
            elsif request.resource != "/" && File.exist?("./public#{request.resource}")
                puts "Resource: #{request.resource}"
                body = File.binread("./public#{request.resource}")
                content_length = body.bytesize
                content_type = @mime_types[File.extname(request.resource)]
            else
                body = "<h1>epic fail</h1>"
                status = 404
                content_type = "text/html"
            end

            response = Response.new(status, content_type, content_length, body, session)
            response.send
        end
    end
end

