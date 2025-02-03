require_relative 'spec_helper'
require_relative '../lib/request'

describe 'Request' do

    describe 'Get' do
        before do
            @request = Request.new(File.read('../test/example_requests/get-index.request.txt'))
        end

        it 'parses the http method' do
            _(@request.method).must_equal "GET"
        end 

        it 'parses the resource' do
            _(@request.resource).must_equal "/"
        end

        it 'version' do
            _(@request.version).must_equal "HTTP/1.1"
        end

        #it 'headers' do
        #    _(@request.headers).must_equal ""
        #end

        #it 'params' do
        #    _(@request.params).must_equal "HTTP/1.1"
        #end
    end

    # describe 'Simple get-request' do
    
    #     it 'parses the http method' do
    #         request_string = File.read('./test/example_requests/get-index.request.txt')
    #         request = Request.new(request_string)
    #         _(request.method).must_equal :get
    #     end 

    #     it 'parses the resource' do
    #         request_string = File.read('./test/example_requests/get-index.request.txt')
    #         request = Request.new(request_string)
    #         _(request.resource).must_equal "/"
    #     end

        

    # end


end