class Response
  def initialize(status, content, session)
    @status = status
    @content = content
    @session = session
  end

  def send()
    @session.print "HTTP/1.1 #{@status}\r\n"
    @session.print "Content-Type: text/html\r\n"
    @session.print "\r\n"
    @session.print @content
    @session.close
  end
end