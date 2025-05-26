require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

# Handles MIME types
#
# @author Matteo Torquato Perillo
class MimeType
    TYPES = {
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

    # Matches a given file extension with its respective mime type, with a fallback in case the matching fails
    #
    # @param file_extension [String] A file extension, for example "html", "txt", or "png"
    # @return [void]
    def self.lookup(file_extension)
        TYPES[file_extension.downcase] || "application/octet-stream"
    end
end

# Implements a HTTP server that listens for incoming TCP connections
# 
# @author Matteo Torquato Perillo
class HTTPServer

    # Initializes the HTTP server.
    #
    # @param port [Integer] the HTTP port
    # @param router [Router] an instance of Router
    # @return [HTTPServer] a new instance of HTTPServer
    def initialize(port,router)
        @port = port
        @router = router
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

            if route
                body = route[:block].call(request.params).to_s
                status = 200
                content_type = "text/html"
                content_length = body.bytesize
            elsif request.resource != "/" && File.exist?("./public#{request.resource}")
                body = File.binread("./public#{request.resource}")
                content_type = MimeType.lookup(File.extname(request.resource).delete('.'))
                content_length = body.bytesize
            else
                body = "<h1>error 404</h1>"
                status = 404
                content_type = "text/html"
                content_length = body.bytesize
            end

            response = Response.new(status, content_type, content_length, body, session)
            response.send
        end
    end
end

