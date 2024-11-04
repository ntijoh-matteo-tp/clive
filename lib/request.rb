class Request
  def initialize(requestString)
    requestStringSplit = requestString.split(' ')
    p requestStringSplit
    @method, @resource, @version = requestStringSplit
    p requestStringSplit.drop(3)

    pp "Method: " + @method, "Resource: " + @resource, "Version: " + @version
  end
end

requestString = File.read("../test/example_requests/get-examples.request.txt")
Request.new(requestString)
