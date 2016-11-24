module Jubla::Event::ParticipationMailer
  extend ActiveSupport::Concern

  CONTENT_SIGNOUT = 'event_application_signout'

  def signout(event, person)
    @event = event
    @person = person

    custom_content_mail(@person,
                        CONTENT_SIGNOUT,
                        { 'recipient-name' => @person.greeting_name,
                          'event-details' => event_without_participation })
  end

  def event_without_participation
    infos = []
    infos << @event.name
    date_label = @event.class.human_attribute_name(:dates)
    date_formatted = @event.dates.map(&:to_s).join('<br/>')
    infos << "#{date_label}:<br/>#{date_formatted}"
    infos.compact.join('<br/><br/>')
  end
end
