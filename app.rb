require_relative 'clive'

router = Router.new

router.add_route(:get, '/banananana') do
  File.read("public/index.html")
end