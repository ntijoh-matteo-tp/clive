# Handles the response to the client by printing requested information to the TCP socket
#
# @author Matteo Torquato Perillo
class Response

  # Initializes a http response using the parameters given from a http request
  #
  # @param status [Integer] a three-digit integer, the http status code
  # @param content_type [String] the type of content in the body of the http request 
  # @param content_length [Integer, NilClass] the amount of bytes of data in the body of the request
  # @param content [String] the information within the body of the request
  # @param session [TCPSocket] represents the TCP socket
  # @return [Response] a new instance of Response
  def initialize(status, content_type, content_length, content, session)
    @status = status
    @content_type = content_type
    @content_length = content_length
    @content = content
    @session = session
  end

  # Prints information from the request and route into the terminal and displays the body on the browser
  #
  # @return [void]
  def send()
    @session.print "HTTP/1.1 #{@status}\r\n"
    @session.print "Content-Type: #{@content_type}\r\n"
    @session.print "Content-Length: #{@content_length}\r\n"
    @session.print "\r\n"
    @session.print @content
    @session.close
  end
end