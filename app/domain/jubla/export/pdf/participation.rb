# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Export::Pdf
  module Participation
    class PersonAndEvent < Export::Pdf::Participation::PersonAndEvent

      private

      def person_attributes
        super + [:j_s_number]
      end
    end
    class EventDetails < Export::Pdf::Participation::EventDetails
      def render
        super
        render_condition if condition?
      end

      private

      def render_condition
        with_count(Event::Course::Condition.model_name.human) do
          text event.condition.content
        end
      end

      def condition?
        course? && event.condition.present?
      end
    end

    class Header < Export::Pdf::Participation::Header
      def image_path
        HitobitoJubla::Wagon.root.join('app/assets/images/logo_jubla.png')
      end
    end

    class Confirmation <  Export::Pdf::Participation::Confirmation

      def render_heading
        super
        render_remarks if event.remarks?
        render_signature if event.signature?
        render_signature_confirmation if signature_confirmation?
      end

      private

      def render_remarks
        y = cursor

        with_settings(line_width: 0.9, fill_color: 'cccccc') do
          fill_and_stroke_rectangle [0, y], bounds.width, 70
        end

        pdf.bounding_box([0 + 5, y - 5], width: bounds.width, height: 65) do
          shrinking_text_box event.remarks
        end
        move_down_line
      end

      def render_signature_confirmation
        render_signature(event.signature_confirmation_text)
      end

      def render_signature(header = Event::Role::Participant.model_name.human)
        y = cursor
        render_boxed(-> { text header; label_with_dots(date_and_location) },
                     -> { move_down_line; label_with_dots(t('.signature')) })
        move_down_line
      end

      def signature_confirmation?
        event.signature_confirmation? && event.signature_confirmation_text?
      end

      def date_and_location
        [Event::Date.model_name.human,
         Event::Date.human_attribute_name(:location)].join(' / ')
      end

      def label_with_dots(content)
        text content
        move_down_line
        text '.' * 55
      end
    end


    class Runner < Export::Pdf::Participation::Runner
      def sections
        [Header,
         PersonAndEvent,
         Export::Pdf::Participation::Specifics,
         Confirmation,
         EventDetails]
      end
    end

  end
end
