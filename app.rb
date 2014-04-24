require 'sinatra'
require 'xmlsimple'
require 'rest_client'

post '/notify' do
	uf_data = XmlSimple.xml_in(request.body.read)

	author_name = uf_data["author-name"].first
	branch      = uf_data["branch"].first
	revision    = uf_data["revision"].first[0..6]
	message     = uf_data["message"].first

	slack_data = {
		:username => author_name + " (Commit)",
		:text => "[" + branch + "] " + revision + ": " + message
	}.to_json

	RestClient.post( params[:url], slack_data, :content_type => 'application/json')
end