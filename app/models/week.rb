class Week < ActiveRecord::Base
  belongs_to :user
  has_many :courses, conditions: proc { "week_rev = #{self.rev}" }

  before_save :set_default_rev

  attr_accessible :number, :rev, :user_id

  private

  def set_default_rev
    self.rev = 0 if self.rev.nil?
  end
end
