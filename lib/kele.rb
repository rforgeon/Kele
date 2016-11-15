require 'httparty'

class Kele
  include HTTParty
  attr_reader :auth_token, :session

  def initialize(username,password)
    @api_url = 'https://www.bloc.io/api/v1'
    @auth_token = self.class.post(@api_url + '/sessions', body: { email: username, password: password })["auth_token"]
    raise StandardError.new('Invalid credentials') unless @auth_token
  end

  def get_me
    response = self.class.get(@api_url + '/users/me', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(@api_url + 'mentors/'+mentor_id.to_s+'/student_availability', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(@api_url + '/roadmaps/'+checkpoint_id.to_s, headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_messages(*pg_number)
    if pg_number[0] === nil
      response = self.class.get(@api_url + '/message_threads', headers: { "authorization" => @auth_token })
    else
      pg_num = pg_number[0]
      response = self.class.get(@api_url + '/message_threads', headers: { "authorization" => @auth_token }, body: {"page" => pg_num})
    end
    JSON.parse(response.body)
  end

  def create_submission(checkpoint_id, enrollment_id, assignment_branch, assignment_commit_link, comment)
    response = self.class.get(@api_url + '/checkpoint_submissions', headers: { "authorization" => @auth_token },
                                                                    body: {"assignment_branch" => assignment_branch,
                                                                          "assignment_commit_link" => assignment_commit_link,
                                                                          "checkpoint_id" => checkpoint_id,
                                                                          "comment" => comment,
                                                                          "enrollment_id" => enrollment_id })
    JSON.parse(response.body)
  end


end
