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


  def get_messages(page_number=nil) #if no page number is specified, all messages will be returned
    if page_number == nil
      response = self.class.get("/message_threads/", headers: { "authorization" => @user_auth_code })
    else
      response = self.class.get("/message_threads",
        body: {page: page_number},
        headers: { "authorization" => @user_auth_code })
    end

    JSON.parse(response.body)
  end


  def create_message(sender, recipient_id, token, subject, message)
    response = self.class.post("/messages/", headers: { "authorization" => @user_auth_code },
      body: {
        sender: sender,
        recipient_id: recipient_id,
        token: token,
        subject: subject,
        "stripped-text": message
      })

      if response["success"]
        puts "Message has successfully sent"
      else
        puts "Message failed to send"
      end

      puts response

      JSON.parse(response.body)["success"]
    end

    def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
      enrollment_id = self.get_me["current_enrollment"]["id"]

      response = self.class.post("/checkpoint_submissions/", headers: { "authorization" => @user_auth_code },
        body: {
          assignment_branch: assignment_branch,
          assignment_commit_link: assignment_commit_link,
          checkpoint_id: checkpoint_id,
          comment: comment,
          enrollment_id: enrollment_id
        })

        if response["success"]
          puts "Checkpoint has been successfully submitted"
        else
          puts "Checkpoint has failed to send"
        end

        JSON.parse(response.body)
      end

    end
