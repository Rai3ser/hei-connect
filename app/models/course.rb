# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  date        :datetime
#  length      :integer
#  kind        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ecampus_id  :integer
#  section_id  :integer
#  group_id    :integer
#  broken_name :string(255)
#

class Course < ActiveRecord::Base
  has_many :course_rooms, dependent: :delete_all
  has_many :rooms, through: :course_rooms
  has_many :course_teachers, dependent: :delete_all
  has_many :teachers, through: :course_teachers
  has_many :course_users, dependent: :delete_all
  has_many :users, through: :course_users

  belongs_to :section
  belongs_to :group

  attr_accessible :ecampus_id, :date, :length, :kind, :broken_name

  scope :current_weeks, lambda { where("date >= ?", Time.zone.now.beginning_of_week).order("date ASC") }

  def name
    if self.broken_name.present?
      self.broken_name
    else
      "#{self.kind} - #{self.section.name}"
    end
  end

  def description
    if self.broken_name.present?
      "E-Campus ne donne pas plus d'informations."
    else
      desc = "#{self.kind} de #{self.section.code} (#{self.section.name})"
      if self.teachers.any?
        desc += "\r\nPar #{self.teachers.join ', '}."
      end

      desc
    end
  end

  def place
    if self.rooms.any?
      self.rooms.join ', '
    else
      "Lieu inconnu"
    end
  end

  def to_fullcalendar_event
    {
        id: self.id,
        title: "#{name}, #{place}",
        start: self.date,
        end: self.date + self.length.minutes,
        allDay: false
    }
  end
end
