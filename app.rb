require_relative 'clive'

r = Router.new

r.get('/') do
  File.read("public/index.html")
end
r.get('/add/:num1/:num2') do |params|
  File.read("public/index.html")
end

#/user/5/posts/3
#/user/:user_id/posts/:post_id 

server = HTTPServer.new(4567, r)
server.start