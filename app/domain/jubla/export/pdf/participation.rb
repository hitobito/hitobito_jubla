# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Export::Pdf
  module Participation

    # jubla_ci wagon is not present when running tarantula
    JUBLA_CI = Wagons.find('jubla_ci')

    class Header < Export::Pdf::Participation::Header

      def render_image
        if JUBLA_CI
          image_path = JUBLA_CI.root.join('app/assets/images/logo_jubla_plain.png')
          image image_path, at: [bounds.width - 60, cursor + 30], width: 60
        end
      end

    end

    class PersonAndEvent < Export::Pdf::Participation::PersonAndEvent

      class Person < Export::Pdf::Participation::PersonAndEvent::Person

        def render
          super
          labeled_attr(:originating_flock)
          labeled_attr(:originating_state)
        end

        def person_attributes
          super + [:j_s_number]
        end

        def address_details
          zip_code, town = super
          [zip_code, [town, person.canton].reject(&:blank?).join(', ')]
        end
      end

      self.person_section = Person

    end

    class Confirmation <  Export::Pdf::Participation::Confirmation

      def render
        first_page_section do
          render_read_and_agreed
          render_signature if event.signature?
          render_signature_confirmation if signature_confirmation?
          render_contact_address if contact
          render_remarks if event.remarks?
        end
      end

      private

      def render_remarks
        y = cursor

        with_settings(line_width: 0.9, fill_color: 'cccccc') do
          fill_and_stroke_rectangle [0, y], bounds.width, 70
        end

        pdf.bounding_box([0 + 5, y - 5], width: bounds.width - 10, height: 65) do
          shrinking_text_box event.remarks
        end
        move_down_line
      end

      def render_signature_confirmation
        render_signature(event.signature_confirmation_text, '.signature_confirmation')
      end

      def render_signature(header = Event::Role::Participant.model_name.human, key = '.signature')
        y = cursor
        render_boxed(-> { text header; label_with_dots(location_and_date) },
                     -> { move_down_line; label_with_dots(t(key)) })
        move_down_line
      end

      def signature_confirmation?
        event.signature_confirmation? && event.signature_confirmation_text?
      end

      def location_and_date
        [Event::Date.human_attribute_name(:location),
         Event::Date.model_name.human].join(' / ')
      end

      def label_with_dots(content)
        text content
        move_down_line
        text '.' * 55
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
          text event.condition.content, :inline_format => true
        end
      end

      def condition?
        course? && event.condition.present?
      end

      def requirements?
        requirements = [event.application_conditions]

        if course?
          requirements += [event_kind.minimum_age,
                           event_kind.qualification_kinds('precondition', 'participant')]
        end

        requirements.any?(&:present?)
      end

    end


    class Runner < Export::Pdf::Participation::Runner

      private

      def customize(pdf)
        if JUBLA_CI
          font_path = JUBLA_CI.root.join('app/assets/fonts')

          pdf.font_families.update('Century Gothic' => {
            normal: font_path.join('century-gothic.ttf'),
            bold: font_path.join('century-gothic-b.ttf'),
            italic: font_path.join('century-gothic-i.ttf'),
            bold_italic: font_path.join('century-gothic-b.ttf')
          })

          pdf.font 'Century Gothic'
        end
        pdf.font_size 9
      end

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
