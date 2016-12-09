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

# Expected API:
# email does not exist: 2xx and non-null user-id
# email does exist and empty password: 401
# email does exist and incorrect password: 401
# email does exist and correct password: 2xx and non-null user-id

post "/api/sessions" do
  body = JSON.parse request.body.read
  attributes = body.dig("data", "attributes")
  email = attributes.fetch("email")
  password = attributes.fetch("password")

  content_type "application/vnd.api+json"

  if email == "user1@example.net"
    if password == "rubbish"
      user_id = SecureRandom.uuid
      session[:user_id] = user_id
      status 201
      body JSON.dump(json_response(user_id))
    else
      status 401
    end
  else
    user_id = SecureRandom.uuid
    status 200
    body JSON.dump(json_response(user_id))
  end
end

post "/api/lost-password" do
  body = JSON.parse request.body.read
  attributes = body.dig("data", "attributes")
  email = attributes.fetch("email")

  puts "Send login email to #{email}"

  status 204
end

get "/dashboard" do
  "Welcome #{request.cookies.inspect}!"
end

def json_response(user_id)
  {
    data: {
      type: "sessions",
      id: SecureRandom.uuid,
      attributes: { "user-id" => user_id }
    }
  }
end
