require 'spec_helper'

feature 'User checks its schedule' do

  before :each do
    sign_out
    user.user_ok!
    user.schedule_ok!
  end

  given(:id)       { 'h01234' }
  given(:password) { 'password' }
  given!(:user) { create :user, ecampus_id: id, password: password}

  given(:room)    { create :room }
  given(:course)  { create :course, rooms:[room], section: create(:section)  }

  context 'when schedule is NOT empty' do
    before :each do
      user.courses << course
    end

    scenario 'on dashboard home', js: true do
      sign_in_with id, password

      expect(page).to have_content 'Emploi du temps'
      expect(page).to have_content course.name
      expect(page).to have_content room.name
    end

    scenario 'on courses home', js: true do
      sign_in_with id, password
      visit dashboard_courses_path ecampus_id: user.ecampus_id

      expect(page).to have_content 'Flux iCalendar'
      expect(page).to have_content 'Emploi du temps'
      expect(page).to have_content course.name
      expect(page).to have_content room.name
    end
  end

  context 'when schedule is empty' do
    scenario 'on dashboard home', js: true do
      sign_in_with id, password

      expect(page).to have_content 'Emploi du temps'
      expect(page).to have_content 'Aucun cours pour cette semaine et la semaine suivante.'
    end

    scenario 'on courses home', js: true do
      sign_in_with id, password
      visit dashboard_courses_path ecampus_id: user.ecampus_id

      expect(page).to have_content 'Flux iCalendar'
      expect(page).to have_content 'Emploi du temps'
      expect(page).to have_content 'Aucun cours pour cette semaine et la semaine suivante.'
    end
  end

  context 'when schedule is unknown' do
    before :each do
      user.schedule_unknown!
    end

    scenario 'on dashboard home', js: true do
      sign_in_with id, password

      expect(page).to have_content 'Emploi du temps'
      expect(page).to have_content 'Aucun cours pour l\'instant.'
    end

    scenario 'on courses home', js: true do
      sign_in_with id, password
      visit dashboard_courses_path ecampus_id: user.ecampus_id

      expect(page).to have_content 'Flux iCalendar'
      expect(page).to have_content 'Emploi du temps'
      expect(page).to have_content 'Aucun cours pour l\'instant.'
    end
  end

end