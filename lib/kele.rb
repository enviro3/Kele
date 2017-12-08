require "httparty"

class Kele

  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    options = {email: "email", password: "password"}
    @user_auth_code = self.class.post("/sessions", options)
    @bloc_base_api = "https://www.bloc.io/api/v1"
  end
  
end
