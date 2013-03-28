class IcsController < ApplicationController
  def show
    begin
      user = User.find_by_ics_key! params[:key]
    rescue
      redirect_to root_url, alert: "Impossible de trouver de calendrier correspondant."
      return
    end

    user.update_schedule! if user.expired_schedule?

    if stale? user, public: false
      respond_to do |format|
        format.ics do
          calendar =
              Rails.cache.fetch [user, 'icalendar'] do
                cal = RiCal.Calendar

                user.courses.current_weeks.each do |course|
                  cal.add_subcomponent course.to_ical_event
                end

                cal.to_s.gsub!(/\n/, "\r\n")
              end

          render :text => calendar, :content_type => 'text/calendar'
        end
      end
    end
  end
end
