require "http/server"
require "./application/*"

module Application
  # TODO Put your code here
end

Application::Base.new(ARGV, ENV).start do
  HTTP::Server.new(8000) do |request|
    puts "LOL"
    # Importation::Base.save_request(request)
    HTTP::Response.ok "text/plain", ""
  end.listen
end
