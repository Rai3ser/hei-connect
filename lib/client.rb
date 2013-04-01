class Client < RocketPants::Client

  class ApiUser < APISmith::Smash
    property :username
    property :token
  end

  class ApiTeacher < APISmith::Smash
    property :name
  end

  class ApiCourse < APISmith::Smash
    property :id
    property :date, transformer: lambda { |d| Time.zone.parse d }
    property :length
    property :type
    property :group
    property :code
    property :name
    property :room
    property :teachers, tranformer: Client::ApiTeacher
  end

  class ApiWeek < APISmith::Smash
    property :number
    property :courses, transformer: Client::ApiCourse
  end

  class ApiSession < APISmith::Smash
    property :id
    property :name
  end

  class ApiGrade < APISmith::Smash
    property :program
    property :course
    property :semester
    property :type
    property :mark
  end

  class ApiGradeDetailed < APISmith::Smash
    property :program
    property :course
    property :name
    property :date
    property :type
    property :weight
    property :mark
    property :unknown
  end

  class ApiAbsence < APISmith::Smash
    property :date, transformer: lambda { |d| Time.zone.parse d }
    property :length
    property :course
    property :excused
    property :justification
  end

  version 2
  base_uri HEI_CONNECT['base']

  def user(username, password)
    get 'users', extra_query: {user: {username: username, password: password}}, transformer: ApiUser
  end

  def new_user(username, password)
    post 'users', extra_query: {user: {username: username, password: password}}, transformer: ApiUser
  end

  def schedule(user)
    get "schedules/#{user.token}", transformer: ApiWeek
  end
end