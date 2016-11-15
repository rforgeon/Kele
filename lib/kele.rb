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
    response = self.class.get(@api_url + '/mentors/'+mentor_id.to_s+'/student_availability', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(@api_url + '/roadmaps/'+checkpoint_id, headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end


end
