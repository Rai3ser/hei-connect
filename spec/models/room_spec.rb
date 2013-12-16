# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Room do

  describe 'relations' do
    it { should have_many(:courses) }
    it { should have_many(:course_rooms) }
  end

  describe '#to_s' do
    let(:name) { %w(la salle qui tue).sample }
    let(:room) { build :room, name: name }
    subject { room.to_s }
    it { should eq name }
  end

end
