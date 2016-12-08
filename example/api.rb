# rubocop:disable Style/StringLiterals

require "sinatra"
require "json"
require "securerandom"

set :public_folder, __dir__
enable :sessions
set :session_secret, "secret"

get "/" do
  redirect to("/index.html")
end

post "/api/sessions" do
  body = JSON.parse request.body.read
  attributes = body.dig("data", "attributes")
  password = attributes.fetch("password")
  user_id = password == "rubbish" ? SecureRandom.uuid : ""

  response = {
    data: {
      type: "sessions",
      id: SecureRandom.uuid,
      attributes: {
        "user-id" => user_id
      }
    }
  }

  session[:user_id] = user_id unless user_id.empty?

  status 201
  body JSON.dump(response)
end

get "/dashboard" do
  "Welcome #{request.cookies.inspect}!"
end
