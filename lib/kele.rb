require 'httparty'
require 'json'
require '/Users/carolinevurlumis/allbloc/Kele/lib/roadmap.rb'

class Kele

  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    user_info = self.class.post("/sessions", body: { "email": email, "password": password })
    @user_auth_code = user_info['auth_token']
    puts @user_auth_code
    raise 'Invalid email or password' if user_info.code != 200
  end

  def get_me #return current user from Bloc API
    response = self.class.get("/users/me", headers: { "authorization" => @user_auth_code })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id) #Ben's mentor id == 537104
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @user_auth_code })
    JSON.parse(response.body)

  end

end
