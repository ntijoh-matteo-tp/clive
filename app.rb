require_relative 'clive'

router.add_route(:get, '/') do
  File.read("public/index.html")
end