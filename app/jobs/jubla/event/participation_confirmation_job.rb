module Jubla::Event::ParticipationConfirmationJob
  extend Event::ParticipationConfirmationJob

    included do
      def perform
        return unless participation # may have been deleted again

        set_locale
        send_confirmation
        send_approval
        send_signout
      end

      def send_signout
        if participation.person.email.present?
          Event::ParticipationMailer.confirmation(participation).deliver_now
        end
      end

    end
  end
end
