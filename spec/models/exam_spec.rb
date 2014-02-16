# == Schema Information
#
# Table name: exams
#
#  average      :float
#  created_at   :datetime         not null
#  date         :date
#  grades_count :integer
#  id           :integer          not null, primary key
#  kind         :string(255)
#  name         :string(255)
#  section_id   :integer
#  updated_at   :datetime         not null
#  weight       :float
#
# Indexes
#
#  index_exams_on_section_id  (section_id)
#

require 'spec_helper'

describe Exam do

  let!(:known_grade1) { FactoryGirl.build :grade, mark: 10 }
  let!(:known_grade2) { FactoryGirl.build :grade, mark: 11 }
  let(:known_grade3) { FactoryGirl.build :grade, mark: 12 }
  let!(:unknown_grade1) { FactoryGirl.build :grade, unknown: true }
  let(:unknown_grade2) { FactoryGirl.build :grade, unknown: true }
  let(:exam) { FactoryGirl.create :exam, kind: 'Cours', grades: [ known_grade1, known_grade2, unknown_grade1 ] }

  describe 'relations' do
    it { should belong_to(:section) }
    it { should have_many(:grades) }
  end

  describe 'should update grades and compute average' do
    context 'when associated grades number goes up' do
      it 'should increase grades count when the new grade is known and update average' do
        exam.update_average_and_counter
        previous_count = exam.grades_count
        previous_average = exam.average

        exam.grades << known_grade3
        exam.update_average_and_counter
        new_count = exam.grades_count
        new_average = exam.average

        previous_count.should == 2
        previous_average.should == 10.5
        new_count.should == 3
        new_average.should == 11
      end

      it 'should not change grades count when the new grade is unknown and update average' do
        exam.update_average_and_counter
        previous_count = exam.grades_count
        previous_average = exam.average

        exam.grades << unknown_grade2
        exam.update_average_and_counter
        new_count = exam.grades_count
        new_average = exam.average

        previous_count.should == 2
        previous_average.should == 10.5
        new_count.should == 2
        new_average.should == 10.5
      end
    end

    context 'when associated grades number goes down' do
      it 'should decrease grades count when the deleted grade is known and update average' do
        exam.update_average_and_counter
        previous_count = exam.grades_count
        previous_average = exam.average

        exam.grades.delete known_grade2
        exam.update_average_and_counter
        new_count = exam.grades_count
        new_average = exam.average

        previous_count.should == 2
        previous_average.should == 10.5
        new_count.should == 1
        new_average.should == 10
      end

      it 'should not change grades count when the deleted grade is unknown and update average' do
        exam.update_average_and_counter
        previous_count = exam.grades_count
        previous_average = exam.average

        exam.grades.delete unknown_grade1
        exam.update_average_and_counter
        new_count = exam.grades_count
        new_average = exam.average

        previous_count.should == 2
        previous_average.should == 10.5
        new_count.should == 2
        new_average.should == 10.5
      end
    end
  end
end
