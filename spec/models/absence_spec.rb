# spec/models/contact.rb
require 'spec_helper'

describe Absence do
  it 'should have a valid factory' do
    FactoryGirl.create(:absence).should be_valid
  end

  it 'should be of correct type' do
    excused_absence =  FactoryGirl.build :absence, excused: true
    justified_absence =  FactoryGirl.build :absence, excused: false
    bad_absence =  FactoryGirl.build :absence, excused: false, justification: ''

    excused_absence.type.should == Absence::TYPE_EXCUSED
    justified_absence.type.should == Absence::TYPE_JUSTIFIED
    bad_absence.type.should == Absence::TYPE_NOTHING
  end
end