class Response
  def initialize(status, content_type, content, session)
    @status = status
    @content_type = content_type
    @content = content
    @session = session
  end

  def send()
    @session.print "HTTP/1.1 #{@status}\r\n"
    @session.print "Content-Type: #{@content_type}\r\n"
    @session.print "\r\n"
    @session.print @content
    @session.close
  end
end